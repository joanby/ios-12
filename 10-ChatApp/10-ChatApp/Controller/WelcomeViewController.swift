//
//  ViewController.swift
//  10-ChatApp
//
//  Created by Juan Gabriel Gomila Salas on 25/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if Auth.auth().currentUser != nil {
            //el usuario ya está logeado
            self.performSegue(withIdentifier: "goToChat", sender: self)
        }
        
    }


}

