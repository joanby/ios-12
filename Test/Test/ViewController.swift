//
//  ViewController.swift
//  Test
//
//  Created by Juan Gabriel Gomila Salas on 4/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrapeNYCMetalScene()
    }

    func scrapeNYCMetalScene() -> Void {
        Alamofire.request("https://udemy.com/u/juangabriel2").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    
    func parseHTML(html: String) -> Void {
        // Finish this next
        
        do{
        let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            
            
            // Search for nodes by CSS selector
            for show in doc.css("div") {
                
                print(show.text)
                //print(show["src"])
                
                
                /*// Strip the string of surrounding whitespace.
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                // All text involving shows on this page currently start with the weekday.
                // Weekday formatting is inconsistent, but the first three letters are always there.
                let regex = try! NSRegularExpression(pattern: "^(mon|tue|wed|thu|fri|sat|sun)", options: [.caseInsensitive])
                
                if regex.firstMatch(in: showString, options: [], range: NSMakeRange(0, showString.characters.count)) != nil {
                    print("\(showString)\n")
                }*/
            }
        } catch{
            print(error)
        }
    }

}

