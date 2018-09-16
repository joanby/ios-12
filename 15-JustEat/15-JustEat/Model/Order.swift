//
//  Order.swift
//  15-JustEat
//
//  Created by Juan Gabriel Gomila Salas on 15/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation

struct Order: Codable, Hashable {
    var cupcake : Product
    var toppings : Set<Product>
    
    var name : String {
        if toppings.count == 0{
            return cupcake.name
        }else{
            let toppingNames = toppings.map {
                $0.name.lowercased()
            }
            return "\(cupcake.name) con \(toppingNames.joined(separator: ", "))."
        }
    }
    
    var price : Int {
        return toppings.reduce(cupcake.price) { $0 + $1.price }
    }
    
}

extension Order {
    init?(from data: Data?){
        guard let data = data else{
            return nil
            
        }
        
        let decoder = JSONDecoder()
        
        guard let savedOrder = try? decoder.decode(Order.self, from: data) else {
            return nil
        }
        
        cupcake = savedOrder.cupcake
        toppings = savedOrder.toppings
    }
}
