//
//  Note.swift
//  11-NotesOnTheGo
//
//  Created by Juan Gabriel Gomila Salas on 15/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var checked : Bool = false
    @objc dynamic var dateCreation: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "notes")
    
}
