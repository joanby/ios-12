//
//  SongsFactory.swift
//  Web Scrapping
//
//  Created by Oscar Javier Villanueva Prieto on 27/08/18.
//  Copyright © 2018 Oscar Javier Villanueva Prieto. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class SongsFactory {
    var songsURL: String
    var songs : [Song] = [Song]()
    
    init(songsURL: String) {
        self.songsURL = songsURL
        self.scrapeURL()
    }
    
    //MARK: - Alamofire
    func scrapeURL(){
        //Hacemos una petición para traer la página, se ejecuta en un hilo
        Alamofire.request(self.songsURL).responseString { (response) in
            if response.result.isSuccess {
                if let htmlString = response.result.value {
                    self.parse(htmlString)
                }
            }
        }
    }
    
    
    //MARK: - Kanna
    func parse(_ html: String) {
        do {
            //Procesamos el html, Kanna lo agrupa el código
            let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            
            //Nos servirá para guardar temporalmente el nombre de la canción
            var title = ""
            
            //Nos servirá para guardar temporalmente url de la imagen
            var imgURL : String = ""
            
            //Servirá para completar la url y poder acceder a la imagen
            let apple = "https://www.apple.com"
            
            //Obtenemos la lista de canciones desordenada (ul) contenida en un div, por medio de un selector css
            for contenido in doc.css("div.section-content ul") {
                //Obtenemos los elementos de la lista li
                for li in contenido.css("li"){
                    //Sacamos el h3 dentro del li, ya que contiene el nombre de la canción
                    //Guardamos el nombre en nuestra variable temporal
                    for h3 in li.css("h3"){
                        title = h3.text!
                    }
                    
                    //Seleccionamos las imganes, con un selector css
                    for img in li.css("a img"){
                        //Obtenemos el atributo src que trae img y lo sumamos apple para obtener la url
                        imgURL = apple + img["src"]!
                    }
                    
                    //Agregamos esa nueva canción al arreglo
                    self.songs.append(Song(title: title, img: imgURL))
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
   
}
