//
//  Extensions.swift
//  13-ARithmetics
//
//  Created by Juan Gabriel Gomila Salas on 06/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation
extension Int {
    var hasUniqueDigits : Bool {
        let strValue = String(self)
        let uniqueChars = Set(strValue)
        return uniqueChars.count == strValue.count
    }
}
