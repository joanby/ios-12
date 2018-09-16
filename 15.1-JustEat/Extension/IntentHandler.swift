//
//  IntentHandler.swift
//  Extension
//
//  Created by Juan Gabriel Gomila Salas on 16/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, OrderIntentHandling {
    
    
    func handle(intent: OrderIntent, completion: @escaping (OrderIntentResponse) -> Void) {
        guard let order = Order(from: intent) else {
            completion(OrderIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        let response = OrderIntentResponse(code: .success, userActivity: nil)
        response.cupcakeName = intent.cupcakeName
        response.preparationTime = NSNumber(value: 5 + 2 * order.toppings.count)
        
        completion(response)
    }
    
    func confirm(intent: OrderIntent, completion: @escaping (OrderIntentResponse) -> Void) {
        let response = OrderIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }
}
