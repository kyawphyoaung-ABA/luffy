//
//  ContentView.swift
//  Day19-challenge
//
//  Created by random k on 20/06/2023.
//

import SwiftUI

struct ContentView: View {
    init() {
           
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]

            
        }
    @State private var userInput = " "
    @State private var userOutput = " "
    @State private var inputValue = 0.0
    @FocusState private var amountIsFocused : Bool
    
    let units = ["seconds", "minutes", "hours", "day"]
    
    var changedInput : Double {
        var iinputValue = inputValue
        switch userInput{
        case "minutes":
            iinputValue *= 60
        case "hours":
            iinputValue *= 3600
        case "day":
            iinputValue *= 86400
        default :
            iinputValue *= 1
        }
        return iinputValue
    }
    
    var outPutValue : Double {
        var ooutputValue = 0.0
        switch userOutput{
        case "minutes":
            ooutputValue = changedInput / 60
        case "hours":
            ooutputValue = changedInput / 3600
        case "day":
            ooutputValue = changedInput / 86400
        default :
            ooutputValue = changedInput / 1
        }
        return ooutputValue
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [ .gray, .white]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    Spacer()
                    
                    TextField("How many ", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad).focused($amountIsFocused)
                        .font(.system(size: 50)).multilineTextAlignment(.center)
                    
                    Picker(" ", selection: $userInput) {
                        ForEach(units, id: \.self){
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                    
                    Spacer().frame(height: 100)
                    
                 
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.black)
                        .frame(width: 100.0, height: 100.0)
                    Spacer().frame(height: 100)
                    
                    Text(outPutValue, format: .number).font(.system(size: 50))
                        .frame(maxWidth: .infinity, alignment: .center).foregroundColor(.gray)
                    
                    Picker(" ", selection: $userOutput) {
                        ForEach(units, id: \.self){
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 50))
            }
            .navigationTitle("Time Conversion")
                .toolbar{
                    ToolbarItemGroup(placement: .keyboard){
                        Spacer()
                        
                        Button("Done"){
                            amountIsFocused = false
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
