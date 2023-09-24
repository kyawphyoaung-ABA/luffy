//
//  ContentView.swift
//  betterRest
//
//  Created by random k on 01/07/2023.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = "kkk"
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        NavigationStack{
            Form{
                
                Section(header: Text("When do you want to wake up?").font(.headline)){
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)//.labelsHidden()
                }
                
                Section(header:Text("Desired amount of sleep").font(.headline)){
                    Stepper("\(sleepAmount.formatted())hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section(header:Text("Daily coffee intake").font(.headline)){
                    Picker(coffeeAmount == 1 ? "1 cup": "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(0..<21){
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.menu)
                    //Stepper(coffeeAmount == 1 ? "1 cup": "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                }
                
            }.navigationTitle("BetterRest")
                .foregroundColor(.black)
                .background(Color.gray)
                .scrollContentBackground(.hidden)
            
            Spacer().frame(height:50)
            Section{
                Text("your recommend bed time is").font(.system(size: 20))
                Text("----------------------------------------------")
                Text(" \(self.calculateBedtime())").font(.system(size: 70))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    
    func calculateBedtime() -> String {
        var aalertMessage = alertMessage
        do {
            
            let config = MLModelConfiguration()
            let model = try BetterRest_1(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            //alertTitle = "Your idel bedtime is .."
            aalertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }catch{
            //alertTitle = "Error"
            aalertMessage = "Sorry, there was a problem"
        }
        return aalertMessage
        //showingAlert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
