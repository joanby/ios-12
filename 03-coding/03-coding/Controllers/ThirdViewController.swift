//
//  ThirdViewController.swift
//  03-coding
//
//  Created by Juan Gabriel Gomila Salas on 26/6/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var families : [String]  = []
    
    var fonts : [String: [String]] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        families = UIFont.familyNames.sorted(by: { return $0 < $1 })
        
        for fam in families{
            fonts[fam] = UIFont.fontNames(forFamilyName: fam)
        }
        
        print(fonts)
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowFontsForFamily" {
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! FontDetailViewController
            
            let idx = self.tableView.indexPathForSelectedRow!.row
            destinationVC.familyName = self.families[idx]
            destinationVC.fonts = self.fonts[self.families[idx]]!
        }
        
    }
    

    // MARK: - Métodos del protocolo UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.families.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontFamilyCell", for: indexPath)
        let fontFamily = families[indexPath.row]
        cell.textLabel?.text = fontFamily
        cell.textLabel?.font = UIFont(name: fontFamily, size: 20.0)
        return cell
    }
    
    
    //MARK: - Métodos del protocolo UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let fontFamily = families[row]
        let familyFonts = fonts[fontFamily]!
        print(familyFonts)
    }
    
}
