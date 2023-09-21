//
//  ContentView.swift
//  project_1to3
//
//  Created by random k on 28/06/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var score = 0
    @State private var cScore = 0
    @State private var showingScore = false
    @State private var showingClearAlert = false
    @State private var scoreTitle = " "
    @State private var oppChoice = ["scissor", "rock","paper"]
    @State private var urChoice    = ["rock", "paper", "scissor"]
    @State private var computerChoice = "?"
    @State private var userChoice = " "
    @State private var choiceOf1 : Int? = nil
    @State private var selectedOne : Int?   = nil
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack{
            
            
            LinearGradient(gradient: Gradient(colors: [ .black, .white]), startPoint: .top, endPoint: .center)
                .ignoresSafeArea()
            
            
            VStack {
                
                Text("Computer").foregroundColor(.white).frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    ForEach(0..<3){ number in
                        Button {
                            withAnimation{
                                buttonTag(number)
                            }
                        } label: {
                            Image(oppChoice[number])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.radians(.pi))
                                .padding(30)
                                .rotation3DEffect(.degrees(number == choiceOf1 ? animationAmount:0), axis: (x: 0, y: 1, z: 0))
                                .opacity(number == choiceOf1 ? opacity : untappedFlagOpacity(number))
                            
                        }
                    }
                }
                
                
                Spacer()
                VStack{
                    Text("Computer Score = \(cScore)")
                    Text("-----------------------------------------")
                    Text("Rock Paper Scissor").font(.custom(
                        "AmericanTypewriter",
                        fixedSize: 40)).padding(5)
                    Text("-----------------------------------------")
                    Text("Your Score = \(score)")
                }
                Spacer()
                
                
                HStack{
                    ForEach(0..<3){ number in
                        Button {
                            withAnimation{
                                buttonTag(number)
                            }
                        } label: {
                            Image(urChoice[number])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(5)
                                .rotation3DEffect(.degrees(number == selectedOne ? animationAmount:0), axis: (x: 0, y: 1, z: 0))
                                .opacity(number == selectedOne ? opacity : untappedFlagOpacity(number))
                        }
                    }
                }
                
                Text("You").foregroundColor(.black).frame(maxWidth: .infinity, alignment: .leading)
                
            }
            
            .alert(score == 3 ? "Congrate, You win a computer" : "So Sad, You lose to a computer", isPresented: $showingClearAlert){
                Button("Next match", action: clearScore)
            }
            .alert(scoreTitle, isPresented: $showingScore){
                Button("Continue", action: continuee)
            }message: {
                Text("(get 3 points to win)")
               
            }
        }
    }
    
    
    func buttonTag(_ number: Int){
        choiceOf1 = Int.random(in: 0...2)
        computerChoice = oppChoice[choiceOf1!]
        userChoice = urChoice[number]
        selectedOne = number
        animationAmount = 360
        
        if userChoice != computerChoice{
            if choiceOf1 == number{
                cScore += 1
                scoreTitle = "You lose !"
            }else{
                score += 1
                scoreTitle = "You win !"
            }
            
        }else{
            scoreTitle = "Draw !"
            score *= 1
        }
        
        if cScore < 3 && score < 3 {
            showingScore = true
            showingClearAlert = false
        }else {
            showingScore = false
            showingClearAlert = true
        }
        
    }
    func continuee(){
        choiceOf1 = Int.random(in: 0...2)
        selectedOne = nil
        animationAmount = 0.0
    }
    func clearScore(){
        cScore = 0
        score = 0
        choiceOf1 = Int.random(in: 0...2)
        selectedOne = nil
        animationAmount = 0.0
    }
    func untappedFlagOpacity(_ number: Int) -> Double {
        if selectedOne == nil {
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
