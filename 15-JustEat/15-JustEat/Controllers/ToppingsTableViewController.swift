//
//  ToppingsTableViewController.swift
//  15-JustEat
//
//  Created by Juan Gabriel Gomila Salas on 15/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class ToppingsTableViewController: UITableViewController {

    var cupcake : Product!
    var selectedToppings = Set<Product>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Añadir decoración"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pedir ahora", style: .plain, target: self, action: #selector(placeOrder))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ProductsFactory.shared().toppings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToppingCell", for: indexPath)
        let topping = ProductsFactory.shared().toppings[indexPath.row]
        cell.textLabel?.text = "\(topping.name) - \(topping.price)€"
        cell.detailTextLabel?.text = topping.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            fatalError("No hemos podido localizar la celda pulsada... ")
        }
        
        let topping = ProductsFactory.shared().toppings[indexPath.row]
        
        if selectedToppings.contains(topping) {
            cell.accessoryType = .none
            selectedToppings.remove(topping)
        }else {
            cell.accessoryType = .checkmark
            selectedToppings.insert(topping)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @objc func placeOrder(){
        guard let orderViewController = storyboard?.instantiateViewController(withIdentifier: "OrderVC") as? OrderViewController else {
            fatalError("No se ha podido cargar el View Controller del Pedido desde el Storyboard")
        }
        
        orderViewController.cupcake = cupcake
        orderViewController.toppings = selectedToppings
        
        navigationController?.pushViewController(orderViewController, animated: true)
    }

}
