//
//  Message.swift
//  10-ChatApp
//
//  Created by Juan Gabriel Gomila Salas on 06/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

class Message {
    var sender : String = ""
    var body : String = ""
    
    init(sender: String, body: String){
        self.sender = sender
        self.body = body
    }
    
    init(){
        sender = "Juan Gabriel"
        body = "Esto es un mensaje de prueba para la aplicación del curso de iOS"
    }
}
