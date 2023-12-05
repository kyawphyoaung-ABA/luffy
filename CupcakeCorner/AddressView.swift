//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by random k on 2023/11/21.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    
    var body: some View {
        List{
            Section{
                HStack{
                    
                    Image(systemName: "1.circle")
                    Text("Choose types").font(.footnote)
                    
                    
                    Image(systemName: "arrowtriangle.right")
                    
                    Image(systemName: "2.circle.fill")
                    Text("Fill address").font(.footnote)
                    
                    Image(systemName: "arrowtriangle.right")
                    
                    Image(systemName: "3.circle")
                    Text("Check out").font(.footnote)
                    
                }
                
            }
            
            Text("Fill address").font(.headline)
                .padding()
                .background(Color.gray.opacity(0.15))
            
            Section{
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            Section{
                NavigationLink("Check out"){
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
            
          
        }
        .listStyle(.plain)
    }
}

#Preview {
    AddressView(order: Order())
}
