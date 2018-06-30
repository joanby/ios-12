//
//  FirstViewController.swift
//  03-coding
//
//  Created by Juan Gabriel Gomila Salas on 26/6/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var sliderAge: UISlider!
    
    var userAge = -1
    var userName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateAgeLabel()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Cerramos el teclado
        textField.resignFirstResponder()
        
        print("Hemos pulsado la tecla enter en un text field")
        
        //Recuperamos el contenido del textField, si es que existe
        if let theText = textField.text {
            print(theText)
            self.userName = theText
        }
        
        //Indicamos la finalización de la edición del textField
        return true
        
    }
    
    
    @IBAction func sliderAgeMoved(_ sender: UISlider) {
       self.updateAgeLabel()
    }
    
    func updateAgeLabel(){
        self.userAge = Int(self.sliderAge.value)
        self.labelAge.text = "\(self.userAge)"
    }
    
    
    @IBAction func validateData(_ sender: UIButton) {
        
        
        let shouldEnterTheParty = (userName == "Juan Gabriel") || (userAge>=18) //&&
        
        if shouldEnterTheParty {
            print("Bienvenido a la fiesta")
            self.view.backgroundColor = UIColor(red: 49.0/255.0, green: 237.0/255.0, blue: 93.0/255.0, alpha: 0.7)
        } else {
            print("Lo siento, esta fiesta es privada. No tienes acceso....")
            self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 50.0/250.0, blue: 50.0/255.0, alpha: 0.8)
        }
        
        /*if userName == "Juan Gabriel" {
            print("Puedes pasar a la fiesta por ser JB")
            self.view.backgroundColor = UIColor(red: 49.0/255.0, green: 237.0/255.0, blue: 93.0/255.0, alpha: 0.7)
        } else {
            if userAge >= 18 {
                print("Puedes pasar a la fiesta por ser mayor de edad")
                self.view.backgroundColor = UIColor(red: 50.0/255.0, green: 160.0/255.0, blue: 250.0/255.0, alpha: 0.7)
            } else {
                print("Lo siento, esta fiesta es privada. No tienes acceso....")
                self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 50.0/250.0, blue: 50.0/255.0, alpha: 0.8)
            }
        }*/
    }
    
    
    
    

}

