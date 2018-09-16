//
//  ProductsFactory.swift
//  15-JustEat
//
//  Created by Juan Gabriel Gomila Salas on 15/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation

class ProductsFactory {
    var cupcakes = [Product]()
    var toppings = [Product]()
    
    private static var sharedFactory : ProductsFactory = {
        let factory = ProductsFactory()
        //configuración adicional
        return factory
    }()
    
    private init() {
        cupcakes = loadProduct(name: "cupcakes")
        toppings = loadProduct(name: "toppings")
    }
    
    private func loadProduct(name: String) -> [Product]{
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            fatalError("No se ha encontrado el fichero \(name).json en la aplicación")
        }
        
        var tempProducts = [Product]()
        if let data = try? Data(contentsOf: url){
            let decoder = JSONDecoder()
            tempProducts = (try? decoder.decode([Product].self, from: data)) ?? [Product]()
            tempProducts.sort {
                return $0.name < $1.name
            }
        }
        
        return tempProducts
    }
    
    class func shared() -> ProductsFactory {
        return sharedFactory
    }
}
