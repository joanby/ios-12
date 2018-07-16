//
//  ViewController.swift
//  06-WebScrapping
//
//  Created by Juan Gabriel Gomila Salas on 7/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import Alamofire
import Kanna


class ViewController: UICollectionViewController {

    let urlName = "https://www.apple.com/itunes/charts/songs"//"http://juangabrielgomila.com/blog/"
    
    var factory : SongsFactory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadItemsInCollectionView),
                                               name: NSNotification.Name("SongsUpdated"), object: nil)
        
        factory = SongsFactory(songsUrl: urlName)

        
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(factory.songs.count)
        
        return factory.songs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCell", for: indexPath) as! SongCell
        cell.labelSong.text = factory.songs[indexPath.row].title
        cell.labelAuthor.text = factory.songs[indexPath.row].authorName
        cell.imageViewSong.downloadedFrom(link: factory.songs[indexPath.row].imageUrl)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(factory.songs[indexPath.row].itunesUrl)
        
        if let url = URL(string: factory.songs[indexPath.row].itunesUrl){
            UIApplication.shared.open(url, options: [:]) { (success) in
                print("Hemos ido a la canción: \(self.factory.songs[indexPath.row].title)")
            }
        }
    }
    
    
    @objc func reloadItemsInCollectionView(){
        self.collectionView.reloadData()
    }
    
}

