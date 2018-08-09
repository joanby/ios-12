//
//  ViewController.swift
//  10-ChatApp
//
//  Created by Juan Gabriel Gomila Salas on 25/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SVProgressHUD.show()
        if Auth.auth().currentUser != nil {
            //el usuario ya está logeado
            SVProgressHUD.dismiss(withDelay: 0.5)
            self.performSegue(withIdentifier: "goToChat", sender: self)
        }else{
            SVProgressHUD.dismiss()
        }
        
    }


}

