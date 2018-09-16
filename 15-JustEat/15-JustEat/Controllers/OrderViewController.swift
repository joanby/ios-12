//
//  ViewController.swift
//  15-JustEat
//
//  Created by Juan Gabriel Gomila Salas on 15/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import Intents

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
        
        let activity = NSUserActivity(activityType: "com.frogames.JustEat.order")
        
        let orderName = order.name
        
        if order.cupcake.name.last == "a" {
            activity.title = "Pedir una \(orderName)"
        } else {
            activity.title = "Pedir un \(orderName)"
        }
        
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        
        
        let encoder = JSONEncoder()
        if let orderData = try? encoder.encode(order){
            activity.userInfo = ["order" : orderData]
        }
        
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(orderName)
        
        activity.suggestedInvocationPhrase = "¡Quiero un postre!"
        self.userActivity = activity
    }

    
    @objc func done(){
        navigationController?.popToRootViewController(animated: true)
    }

}

