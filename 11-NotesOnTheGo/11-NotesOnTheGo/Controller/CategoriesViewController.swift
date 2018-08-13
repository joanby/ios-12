//
//  ViewController.swift
//  11-NotesOnTheGo
//
//  Created by Juan Gabriel Gomila Salas on 09/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class CategoriesViewController: UICollectionViewController {

    let categoriesArray = ["Compras", "Tareas de la casa", "Ocio"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Categories VC cargado")
    }
    
    
    //MARK:- Métodos de Collection View Data Source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryLabel.text = categoriesArray[indexPath.row]
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNoteList", sender: self)
    }
    
}

