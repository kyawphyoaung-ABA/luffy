//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by random k on 2023/11/21.
//

import SwiftUI
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
struct CheckoutView: View {
    var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    var body: some View {
        
        List{
            Section{
                HStack{
                    
                    Image(systemName: "1.circle")
                    Text("Choose types").font(.footnote)
                    
                    
                    Image(systemName: "arrowtriangle.right")
                    
                    Image(systemName: "2.circle")
                    Text("Fill address").font(.footnote)
                    
                    Image(systemName: "arrowtriangle.right")
                    
                    Image(systemName: "3.circle.fill")
                    Text("Check out").font(.footnote)
                    
                }
                
            }
            
            Text("Check out").font(.headline)
                .padding()
                .background(Color.gray.opacity(0.15))
            
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),scale:3){image in
                    image
                        .resizable()
                        .scaledToFit()
                }placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                Text("Your total is \(order.cost,format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order"){
                    Task{
                        await placeOrder()
                    }
                    
                }
                .buttonStyle(GrowingButton())
            }
         
        }
        .listStyle(.plain)
        .alert("Thank you!", isPresented: $showingConfirmation){
            Button("OK"){}
        }message: {
            Text(confirmationMessage)
        }
    }
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity1)x \(Order.types[decodedOrder.type].lowercased())\(decodedOrder.quantity2)x \(Order.types[decodedOrder.type].lowercased())\(decodedOrder.quantity3)x \(Order.types[decodedOrder.type].lowercased())\(decodedOrder.quantity4)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        }catch{
            print("Checkout failed: \(error.localizedDescription)")
        }
        
        
    }
}

#Preview {
    CheckoutView(order: Order())
}
