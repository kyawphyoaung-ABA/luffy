//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by random k on 2023/11/21.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    var body: some View {
        NavigationStack{
            
            List{
                Section{
                    HStack{
                        
                        Image(systemName: "1.circle.fill")
                        Text("Choose types").font(.footnote)
                        
                        
                        Image(systemName: "arrowtriangle.right")
                        
                        Image(systemName: "2.circle")
                        Text("Fill address").font(.footnote)
                        
                        Image(systemName: "arrowtriangle.right")
                        
                        Image(systemName: "3.circle")
                        Text("Check out").font(.footnote)
                        
                    }
                    
                }
                Text("Choose types").font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.15))
          
                
                
                Section{
                    HStack{
                        VStack{
                            Image("Vanilla")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 85, height: 85)
                                .clipShape(Capsule())
                            Text("Vanilla    x\(order.quantity1)")
                        }
                        Stepper("",value: $order.quantity1, in : 3...20).fixedSize()
                        
                        
                        Stepper("",value: $order.quantity2, in : 3...20).fixedSize()
                        VStack{
                            Image("Strawberry")
                            
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 85, height: 85)
                                .clipShape(Capsule())
                            Text("Strawberry x\(order.quantity2)")
                        }
                    }
                    HStack{
                        VStack{
                            Image("Chocolate")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 85, height: 85)
                                .clipShape(Capsule())
                            Text("Chocolate x\(order.quantity3)")
                        }
                        Stepper("",value: $order.quantity3, in : 3...20).fixedSize()
                        
                        
                        Stepper("",value: $order.quantity4, in : 3...20).fixedSize()
                        VStack{
                            Image("Rainbow")
                            
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 85, height: 85)
                                .clipShape(Capsule())
                            Text("Rainbow x\(order.quantity4)")
                        }
                    }
                }
                
                Section{
                
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                   
                }
                
                Section{
                    NavigationLink("Delivery details"){
                        AddressView(order: order)
                    }
                    
                }
                .font(.custom("AmericanTypewriter-Bold", size: 19))
                .padding(.top, 60)
                
             
            }
           
            .listStyle(.plain)
            .navigationTitle("Cupcake Corner")         
            .font(.custom("AmericanTypewriter", size: 15))

        }
    }
}

#Preview {
    ContentView()
}
