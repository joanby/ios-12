//
//  SecondViewController.swift
//  03-coding
//
//  Created by Juan Gabriel Gomila Salas on 26/6/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBOutlet weak var labelNumber: UILabel!
    
    @IBOutlet weak var labelGoldNum: UILabel!
    
    @IBOutlet weak var textviewResult: UITextView!
    
    @IBOutlet weak var stepper: UIStepper!
    
    var fibonacci : [Int] = [0,1]
    
    var fibId = 1
    
    var wantsGoldNum = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel(id: Int(self.stepper.value))
    }

    
    func generateFibNumbers(){
        
        /*if(fibId<=1||fibId>100){
            return
        }*/
        
        //Generar numeros de fib. hasta el fibId
        fibonacci = [0,1]
        
        for i in 2...fibId {
            fibonacci.append(fibonacci[i-1]+fibonacci[i-2])
        }
        
        let fibStr : [String] = fibonacci.compactMap({ String($0)})
        let result : String = fibStr.joined(separator: "\n")
        self.textviewResult.text = result
    }

    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        updateLabel(id: Int(sender.value))
        
    }
    
    func updateLabel(id: Int){
        self.fibId = id
        self.labelNumber.text = "\(self.fibId)"
        generateFibNumbers()
        calculateGoldNum()
    }
    
    @IBAction func switchMoved(_ sender: UISwitch) {
        self.wantsGoldNum = sender.isOn
        calculateGoldNum()
    }
    
    func calculateGoldNum() {
        if (self.wantsGoldNum){
            //hay que generar el número de oro como cociente entre los dos últimos de fibonacci
            let last = Double(fibonacci[fibonacci.count-1])
            let previous = Double(fibonacci[fibonacci.count-2])
            let goldNum = last / previous
            self.labelGoldNum.text = "\(goldNum)"
        } else {
            //ponemos un texto por defcto en la etiqueta...
            self.labelGoldNum.text = "Ver el número de oro"
        }
    }
    
}

