//
//  ViewController.swift
//  11-NotesOnTheGo
//
//  Created by Juan Gabriel Gomila Salas on 09/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//
import CoreData
import UIKit

class CategoriesViewController: UICollectionViewController {

    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.font : UIFont(name: "Papyrus", size: 24.0) ?? UIFont.systemFont(ofSize: 24.0)
        ]*/
        print("Categories VC cargado")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescription]
        do{
            try categoriesArray = context.fetch(request)
        } catch {
            print("Error al recuperar las categorías \(error)")
        }
        collectionView.reloadData()
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
        
        let category = categoriesArray[indexPath.row]
        cell.categoryLabel.text = category.title
        cell.categoryImageView.image = UIImage(data: category.image!)
        cell.categoryImageView.contentMode = .scaleAspectFit
        cell.categoryImageView.layer.borderColor = UIColor(hex: category.colorHex!)?.cgColor
        cell.categoryImageView.layer.borderWidth = 5
        cell.categoryImageView.layer.cornerRadius = 10
        cell.categoryImageView.backgroundColor = UIColor(hex: category.colorHex!)
        cell.categoryLabel.textColor = UIColor(hex: category.colorHex!)
        return cell
    }
    
    var selectedCategory = -1
    //MARK: - Métodos de Collection View Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = indexPath.row
        performSegue(withIdentifier: "ShowNoteList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNoteList" {
            let destinationVC = segue.destination as! NotesTableViewController
            destinationVC.selectedCategory = categoriesArray[selectedCategory]
        }
    }
 
    
    
}

