//
//  MainMenuViewController.swift
//  09-EyesInvaders
//
//  Created by Juan Gabriel Gomila Salas on 19/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isIdleTimerDisabled = true
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GameVC"){
            navigationController?.pushViewController(vc, animated: true)
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
