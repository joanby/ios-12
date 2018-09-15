//
//  Extensions.swift
//  14-ARMuseums
//
//  Created by Juan Gabriel Gomila Salas on 07/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    var width: Float{
        return (boundingBox.max.x - boundingBox.min.x) * scale.x
    }
    
    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }
    
    func pivotToTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, (max.y-min.y) + min.y, 0)
        
    }
    
    func pivotToTopCenter(){
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x)/2, min.y + (max.y - min.y), 0)
    }
    
    func pivotToTopRight() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x + (max.x - min.x), (max.y-min.y) + min.y, 0)
    }
    
    
    func pivotToCenterRight() {
        
    }
    
    func pivotToBottomRight() {
        
    }
    
    
    func pivotToBottomCenter() {
        
    }
    
    
    func pivotToBottompLeft() {
        
    }
    
    
    func pivotToCenterLeft() {
        
    }
}
