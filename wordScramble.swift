//
//  ContentView.swift
//  WordScranble
//
//  Created by random k on 03/07/2023.
//
import MLKit
import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var translatedWords = [String]()
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
    
    var body: some View {
        NavigationView{
            List{
                
                Section{
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                Section{
                    ForEach(Array(zip(usedWords,translatedWords)),id: \.0){ // use of zip array to combine two arrays
                        (a,b) in
                        HStack{
                            Text("\(a) = \(b) ")
                        }
                    }
                }
                
                Section{
                    ForEach(usedWords, id: \.self){
                        word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("word")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
               
            )
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(rootWord)
                        .font(.system(size: 50, weight: .heavy, design: .serif))
                        .foregroundColor(.white)
                    
                }
            }
            .onSubmit(addNewWord)//once a return button is pressed
            .onAppear(perform: startGame) //for once simple show while starting
            .alert(errorTitle, isPresented: $showingError){
                Button("OK", role: .cancel){}
            }message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Text("Score:\(score)")
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("New  |", action: reStart)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Ans   ", action: getAnswer)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("| 翻譯 ", action: translate)
                }
            }
        }
    }
    
    func translate() { //use of google ml kit translate features,https://developers.google.com/ml-kit/language/translation/ios
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .chinese)
        let englishGermanTranslator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        englishGermanTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            // Model downloaded successfully. Okay to start translating.
        }
        for words in usedWords{ //think
            englishGermanTranslator.translate(words) { translatedText, error in
                guard error == nil, let translatedText = translatedText else { return  }
                translatedWords.append(translatedText)
                //            if error == nil, let translatedText = translatedText{
                //                aa = translatedText
                //                print(aa)
                //                return
            }
        }
    }
    //try to use completion handler but not successful
    //    func translatee(word: String, completion: @escaping (_ success: String ) -> Void ){
    //        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .chinese)
    //           let translator = Translator.translator(options: options)
    //           let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true)
    //           translator.downloadModelIfNeeded(with: conditions) { error in
    //               guard error == nil else { return }
    //               translator.translate(word) { translatedText, error in
    //                   guard error == nil, let translatedText = translatedText else { return }
    //                   print(translatedText)
    //                   success = translatedText
    //                   completion(translatedText)
    //               }
    //           }
    //       }
    
    func addNewWord(){  //look at your answer
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) //trimming = eliminateing
        guard answer.count > 3 else {
            wordError(title: "Word is too short", message: "Pls more than 3 alphabet!")
            return }
        guard isOriginal(word: answer)else{
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        guard isPossible(word: answer)else{
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        guard isReal(word: answer)else{
            wordError(title: "Word not recognized", message: "Your word wrong!")
            return
        }
        withAnimation{
            usedWords.insert(answer, at:0)
        }
        newWord = ""
        score += 1
    }
    
    func startGame(){ //put startword from bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){ //check ur file
            if let startWords = try? String(contentsOf: startWordsURL){ //get ur file's content
                let allWords = startWords.components(separatedBy: "\n") //find the line break and give me an array
                if allWords.count > 3{
                    rootWord = allWords.randomElement() ?? "silkworm"
                }
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func getAnswer(){ //to get answer from txt
        if let sstartWordsURL = Bundle.main.url(forResource: "words_alpha", withExtension: "txt"){ //check ur file
            if let sstartWords = try? String(contentsOf: sstartWordsURL){ //get ur file's content
                let aallWords = sstartWords.components(separatedBy: "\n") //find the line break and give me an array
                for words in aallWords{
                    let nswer = words.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    if  isPossible(word: nswer) && isReal(word: nswer) && nswer.count > 3 && isOriginal(word: nswer) {
                        usedWords.append(nswer)
                        
                    } }
                
                return
            }}
        fatalError("Could not load start.txt from bundle.")
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
        
    }
    func reStart(){
        usedWords = [String]()
        translatedWords = [String]()
        rootWord = ""
        startGame()
        score = 0
    }
    
    //check your answer
    func isOriginal(word: String) -> Bool{
        !usedWords.contains(word)
    }
    func isPossible(word: String) -> Bool{
        var tempWord = rootWord
        for letter in word{
            if let pos = tempWord.firstIndex(of: letter){ //use of firstIndex
                tempWord.remove(at: pos)                  //use of remove at
            }else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker() //call api in uikit
        let range = NSRange(location: 0, length: word.utf16.count) //set a range
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en") //check for misspell
        return misspelledRange.location == NSNotFound
    }
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

