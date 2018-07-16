//
//  Extensions.swift
//  06-WebScrapping
//
//  Created by Juan Gabriel Gomila Salas on 8/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadedFrom(link:String, contentMode mode:UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {return}
        downloadedFrom(url: url)
    }
    
    
    func downloadedFrom(url:URL, contentMode mode: UIView.ContentMode = .scaleAspectFit)  {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
}
