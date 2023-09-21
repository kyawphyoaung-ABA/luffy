//
//  ContentView.swift
//  WeeSplit
//
//  Created by random k on 16/06/2023.
//  command+I to clean code

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused : Bool
    
    let tipPercentages = [0, 10, 15, 20, 25]
    
    private var currency: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
    
    var totalCheck: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let amountPerPerson = totalCheck / peopleCount
        return amountPerPerson
    }
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Section{
                    HStack{
                        Text("Enter Amount :").font(.title2)
                        
                        TextField("Amount", value: $checkAmount, format: currency)
                            .keyboardType(.decimalPad).focused($amountIsFocused)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.black)
                    .frame(width: 300, height: 100)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Section{
                    List{
                        VStack{
                            Text("Choose Tip Percentages")
                            Picker("Choose Tip percentage", selection: $tipPercentage) {
                                ForEach(tipPercentages, id: \.self) {
                                    Text($0, format: .percent)
                                }
                            }.pickerStyle(.segmented)
                        }
                        Picker("Choose Number of people", selection: $numberOfPeople){
                            ForEach(2..<50){
                                
                                Text("\($0) people")
                            }
                        }
                        .pickerStyle(.navigationLink)
                        
                    }
                    .listStyle(.plain)
                 
                }
                
                Section{
                    VStack{
                        HStack{
                            Text("Amount Per Person:   ").frame(maxWidth: .infinity, alignment: .leading)
                            Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD")).font(.title2)
                        }
                        HStack{
                            Text("Total Amount :").foregroundColor(tipPercentage==0 ? .red : .white).frame(maxWidth: .infinity, alignment: .leading) //project3 conditional modifier
                            Text(totalCheck, format: .currency(code: Locale.current.currencyCode ?? "USD")).font(.title2)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 100)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                
            }
            .navigationTitle("Sp!it")
            .toolbar{
                ToolbarItemGroup(placement: .keyboard){
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

