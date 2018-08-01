//
//  RootViewController.swift
//  08-ThePriceIsRight
//
//  Created by Juan Gabriel Gomila Salas on 16/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

let model = HousePriceModel()


class ViewController: UIViewController {

    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var labelData: UILabel!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
        updatePredictions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updatePredictions()
    }
    
    
    func updatePredictions(){
        
        var stringValue = ""
        do{
            let prediction = try model.prediction(bathrooms: Double(house.bathrooms),
                                                  cars: Double(house.garage),
                                                  condition: Double(house.condition),
                                                  rooms: Double(house.rooms),
                                                  size: Double(house.size),
                                                  yearBuilt: Double(house.year))
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            stringValue = formatter.string(from: prediction.value as NSNumber) ?? "N/A"
            
        } catch{
            print(error.localizedDescription)
        }
        
        
        self.labelDescription.numberOfLines = 0
        self.labelDescription.text = "\(house)\n\(stringValue)"
        
        if let resultsLabel = self.resultsLabel{
            resultsLabel.text = "\(stringValue)"
            
        }
    }

    @IBAction func dataChanged(_ sender: Any) {

        guard let sender = sender as? UIView else {
            return
        }
        //Desde aquí, sender es un objeto de la clase UIView
        switch sender.tag {
        case 1:
            let sender = sender as! UISegmentedControl
            house.rooms = sender.selectedSegmentIndex + 1
            break
            
        case 2:
            let sender = sender as! UISegmentedControl
            house.bathrooms = sender.selectedSegmentIndex + 1
            break
            
        case 3:
            let sender = sender as! UISegmentedControl
            house.garage = sender.selectedSegmentIndex
            break
            
        case 4:
            let sender = sender as! UIStepper
            self.labelData.text = "\(Int(sender.value))"
            house.year = Int(sender.value)
            break
            
        case 5:
            let sender = sender as! UISlider
            self.labelData.text = "\(Int(sender.value)) m2"
            house.size = Int(sender.value)
            break
            
        case 6:
            let sender = sender as! UISegmentedControl
            house.condition = sender.selectedSegmentIndex
            break
            
        default:
            print("Aquí no entraremos nunca")
        }
        
        self.updatePredictions()

    }
    

}

