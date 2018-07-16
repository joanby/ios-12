//
//  Song.swift
//  06-WebScrapping
//
//  Created by Juan Gabriel Gomila Salas on 8/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation

class Song {
    
    var uuid : String
    var title : String
    var authorName : String
    var itunesUrl : String
    var imageUrl : String
    var imageDownloaded = false
    
    init(title : String, authorName:String, itunesUrl : String, imageUrl : String = "https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/2f/ee/52/2fee52de-5947-dd83-ba88-fc5bdbd72c75/093155174290_cover.jpg/268x0w.jpg") {

        self.uuid = UUID().uuidString

        self.title = title
        self.authorName = authorName
        self.itunesUrl = itunesUrl//.replacingOccurrences(of: "https://", with: "itms://")
        self.imageUrl = imageUrl
    }
    
    
}
