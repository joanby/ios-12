//
//  ViewController.swift
//  02-dices
//
//  Created by Juan Gabriel Gomila Salas on 23/6/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageViewDiceLeft: UIImageView!
    
    @IBOutlet weak var imageViewDiceRight: UIImageView!
    
    var randomDiceIndexLeft : Int = 0
    
    var randomDiceIndexRight : Int = 0
    
    let diceImages : [String]
    
    let nFaces : UInt32
    
    required init?(coder aDecoder: NSCoder) {
        diceImages  = ["dice1", "dice2", "dice3", "dice4", "dice5", "dice6"]
        nFaces = UInt32(diceImages.count)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        generateRandomDices()
    }


    @IBAction func rollPressed(_ sender: UIButton) {
        generateRandomDices()
    }
    
    func generateRandomDices(){

        //Generar aleatoriamente y cambiar el dado izquierdo
        randomDiceIndexLeft = Int(arc4random_uniform(nFaces))
        let nameImageDiceLeft = diceImages[randomDiceIndexLeft]

        //Generar aleatoriamente y cambiar el dado derecho
        randomDiceIndexRight = Int(arc4random_uniform(nFaces))
        let nameImageDiceRight = diceImages[randomDiceIndexRight]

       UIView.animate(withDuration: 0.3,
                      delay: 0,
                      options: UIView.AnimationOptions.curveEaseInOut,
                      animations: {
                        
                        self.imageViewDiceLeft.transform = CGAffineTransform(scaleX: 0.6, y: 0.6).concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/2)).concatenating(CGAffineTransform(translationX: -100, y: 100))
                        
                         self.imageViewDiceRight.transform = CGAffineTransform(scaleX: 0.6, y: 0.6).concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/2)).concatenating(CGAffineTransform(translationX: 100, y: 100))
                        
                        self.imageViewDiceRight.alpha = 0.0
                        self.imageViewDiceLeft.alpha = 0.0

       }) { (completed) in
        
            self.imageViewDiceLeft.transform = CGAffineTransform.identity
            self.imageViewDiceRight.transform = CGAffineTransform.identity
        
            self.imageViewDiceRight.alpha = 1.0
            self.imageViewDiceLeft.alpha = 1.0
        

            self.imageViewDiceLeft.image = UIImage(named: nameImageDiceLeft)
            self.imageViewDiceRight.image = UIImage(named: nameImageDiceRight)
        }
        
        
    }
    
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake{
            generateRandomDices()
        }
        
    }
    
}

