//
//  RegisterViewController.swift
//  10-ChatApp
//
//  Created by Juan Gabriel Gomila Salas on 06/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
   
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var password2TextField: UITextField!
    
    @IBOutlet weak var conditionsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard conditionsSwitch.isOn else {
            //TODO: poner una alerta para indicar al usuario que no ha aceptado las condiciones
            return
        }
        
        guard passwordTextField.text == password2TextField.text else {
            //TODO: las contraseñas no coinciden...
            return
        }
        
        guard let email = emailTextField.text, let pass = passwordTextField.text else{
            //TODO: indicar que el correo no ha sido escrito
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: pass ) { (user, error) in
            if error != nil{
                print(error!)
            }else{
                print("El usuario se ha registrado correctamente =D")
                self.performSegue(withIdentifier: "fromRegistryToChat", sender: self)
            }
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
