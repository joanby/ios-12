//
//  ViewController.swift
//  04-Piano
//
//  Created by Juan Gabriel Gomila Salas on 2/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioPlayer : AVAudioPlayer!
    
    let soundsArray = ["c1", "c1s", "d1", "d1s", "e1", "f1", "f1s", "g1", "g1s", "a1", "a1s", "b1", "c2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func playSound(_ sender: UIButton) {
        let idKey = sender.tag
        let fileName = soundsArray[idKey-1]
        print("Hemos pulsado la tecla \(fileName) ")
    
        if let soundURL : URL = Bundle.main.url(forResource: fileName, withExtension: "mp3"){
            print(soundURL)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch{
                print(error)
            }
            
            audioPlayer.play()
            
            print(audioPlayer.averagePower(forChannel: 0))
        }
    }
    
    
    
    

}

