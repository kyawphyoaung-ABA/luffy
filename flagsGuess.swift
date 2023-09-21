//
//  ContentView.swift
//  guessTheFlags
//
//  Created by random k on 26/06/2023.
//  https://www.hackingwithswift.com/forums/100-days-of-swiftui/day-34-animation-wrap-up-challenge-one/17945

import SwiftUI
struct CapsuleImage : View{         //project3 View composition
    var name : String
    var body: some View{
        Image(name)
            .renderingMode(.original)
        //.clipShape(Capsule())
            .shadow(radius: 5)
        
    }
}                                   //project3

struct ContentView: View {
    @State private var stop = 0
    @State private var score = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var showingClearAlert = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
/*first shuffled the above countries and select first three countries to show on screen, and then use the below code to let user guess from these countries. Then collect the user choice in number and compare with below randomize number*/
    
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var animationAmount = 0.0
    @State private var selectedOne : Int?   = nil
    @State private var opacity = 1.0
    var body: some View {
        ZStack{
            
            
            LinearGradient(gradient: Gradient(colors: [ .black, .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Spacer()
                
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of ")
                            .foregroundColor(.black)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.black)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in
                        /*this foreach is important, it takes one by one. So think in that way*/
                        Button {
                            withAnimation {
                                flagTapped(number)
                            }
                        } label: {
                            CapsuleImage(name: countries[number])
                            //project3
                            /*Image(countries[number])
                             .renderingMode(.original)
                             .clipShape(Capsule())
                             .shadow(radius: 5)*/            //original project2
                            // .rotation3DEffect(.degrees( selectedOne == number   ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .rotation3DEffect(.degrees(number == selectedOne ? animationAmount:0), axis: (x: 0, y: 1, z: 0))
                                .opacity(number == selectedOne ? opacity : untappedFlagOpacity(number))
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert("Congrat! Your final score is \(score)/3", isPresented: $showingClearAlert){
            Button("Next match", action: clearScore)
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        }message: {
            Text("Your score is \(score)")
            
        }
        
    }
    func flagTapped(_ number: Int){
        stop += 1
        selectedOne = number
        animationAmount = 360
        if number == correctAnswer{
            opacity  = 1.0
            scoreTitle = "Correct"
            score += 1
        }else{
            opacity  = 0.33
            scoreTitle = "Wrong! That is the flag of \(countries[number])"
        }
        if stop < 3 {
            showingScore = true
            showingClearAlert = false
        }else{
            showingClearAlert = true
            showingScore = false
        }
    }
    func clearScore(){
        stop = 0
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedOne = nil
        animationAmount = 0.0
        
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        selectedOne = nil
        animationAmount = 0.0
        opacity = 1.0
        
    }
    
    func untappedFlagOpacity(_ number: Int) -> Double {
        if selectedOne == nil || number == correctAnswer {
            return 1.0
        } else {
            return 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
