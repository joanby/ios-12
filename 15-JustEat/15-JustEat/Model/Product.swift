//
//  Product.swift
//  15-JustEat
//
//  Created by Juan Gabriel Gomila Salas on 15/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation

struct Product: Codable, Hashable {
    var name : String
    var description : String
    var price : Int
}
