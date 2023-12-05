//
//  Order.swift
//  CupcakeCorner
//
//  Created by random k on 2023/11/21.
//

import Foundation
@Observable 
class Order: Codable {
    enum CodingKeys: String, CodingKey {
           case _type = "type"
           case _quantity = "quantity"
           case _specialRequestEnabled = "specialRequestEnabled"
           case _extraFrosting = "extraFrosting"
           case _addSprinkles = "addSprinkles"
           case _name = "name"
           case _city = "city"
           case _streetAddress = "streetAddress"
           case _zip = "zip"
       }
    static let types = ["Vanilla","Strawberry","Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 0
    var quantity1 = 3
    var quantity2 = 3
    var quantity3 = 3
    var quantity4 = 3
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false{
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    var hasValidAddress : Bool{
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty{
            return false
        }
        return true
    }
    var cost: Double {
        let quantity = quantity1 + quantity2 + quantity3 + quantity4
        var cost = Double(quantity)*2
        cost += (Double(type)/2)
        if extraFrosting{
            cost += Double(quantity)
        }
        if addSprinkles{
            cost += Double(quantity)/2
        }
        return cost
    }
}
