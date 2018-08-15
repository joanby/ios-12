//
//  Category.swift
//  11-NotesOnTheGo
//
//  Created by Juan Gabriel Gomila Salas on 14/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//
import UIKit
import Foundation

extension Category{
    var color: UIColor? {
        get{
            guard let hex = colorHex else { return nil }
            return UIColor(hex: hex)
        }
        set(newColor){
            if let newColor = newColor {
                colorHex = newColor.toHex
            }
        }
    }
}
