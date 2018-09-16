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
    
    var intent : OrderIntent{
        let intent = OrderIntent()
        intent.cupcakeName = cupcake.name
        intent.toppings = toppings.map {$0.name.lowercased()}
        intent.suggestedInvocationPhrase = "Quiero un \(cupcake.name) ahora mismo!"
        return intent
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
    
    init?(from intent: OrderIntent){
        guard let cupcake = ProductsFactory.shared().findCupcake(from: intent.cupcakeName) else { return nil }
     
        guard let toppings = intent.toppings?.compactMap({
            ProductsFactory.shared().findTopping(from: $0)
        }) else{
            return nil
        }
        
        self.cupcake = cupcake
        self.toppings = Set(toppings)
        
    }
}
