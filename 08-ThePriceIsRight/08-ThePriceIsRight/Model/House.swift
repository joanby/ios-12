//
//  House.swift
//  08-ThePriceIsRight
//
//  Created by Juan Gabriel Gomila Salas on 17/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation

let house = House()

class House: CustomStringConvertible {
    var rooms = 1
    var bathrooms = 1
    var garage = 0
    var year = 1975
    var size = 100
    var condition = 0
 
    var description: String {
        
        let bed = "🛌"
        let bath = "🚽"
        let car = "🚗"
        let star = "⭐️"
        
        var 💤 = ""
        var 🛀 = ""
        var 🏎 = ""
        var 💙 = ""
        
        for _ in 1...rooms{
            💤 = "\(💤)\(bed)"
        }
        
        for _ in 1...bathrooms {
            🛀 = "\(🛀)\(bath)"
        }
        
        if garage > 0 {
            for _ in 1...garage {
                🏎 = "\(🏎)\(car)"
            }
        }
        
        for _ in 0...condition {
            💙 = "\(💙)\(star)"
        }
        
        return """
        Descripción de la casa
        ======================
        \(💤)
        \(🛀)
        \(🏎)
        - Año de construcción: \(year)
        - Superfície: \(size) m2
        \(💙)
        """
    }
    
}
