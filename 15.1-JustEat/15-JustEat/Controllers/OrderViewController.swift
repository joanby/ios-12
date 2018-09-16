//
//  ViewController.swift
//  15-JustEat
//
//  Created by Juan Gabriel Gomila Salas on 15/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

class OrderViewController: UIViewController {

    var cupcake : Product!
    var toppings = Set<Product>()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = imageView.image
        imageView.image = nil
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        //imageView.tintColor = UIColor.red

        let order = Order(cupcake: cupcake, toppings: toppings)
        showOrderDetails(order)
        sendToServer(order)
        donate(order)
        record(order)
        
        title = "Pedido completado"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    
    func showOrderDetails(_ order: Order) {
        orderLabel.text = order.name
        costLabel.text = "\(order.price) €"
    }
    
    func sendToServer(_ order: Order){
        let enconder = JSONEncoder()
        
        do{
            let data = try enconder.encode(order)
            print(data)
            //TODO: Enviar data al server para su posterior procesado en la tienda
        } catch{
            print("Error al enviar el pedido al restaurante... ")
        }
        
    }
    
    func donate(_ order: Order) {
        
        //Sugerencias a través de Intents
        //let suggestions2 = [INShortcut(intent: order.intent)].compactMap{$0}
        //INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions2)
        
        let interaction = INInteraction(intent: order.intent, response: nil)
        interaction.donate { (error) in
            if let error = error {
                print(error)
            }
        }
    }

    
    @objc func done(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func record(_ order: Order)  {
        if let shortcut = INShortcut(intent: order.intent){
            let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            present(vc, animated: true)
        }
        
    }

}

