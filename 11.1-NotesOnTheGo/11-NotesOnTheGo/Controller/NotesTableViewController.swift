//
//  NotesTableViewController.swift
//  11-NotesOnTheGo
//
//  Created by Juan Gabriel Gomila Salas on 12/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class NotesTableViewController: UITableViewController {
    
    var notes: Results<Note>?
    var selectedCategory : Category?{
        didSet{
            loadNotes()
        }
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedCategory?.title
        self.navigationItem.hidesSearchBarWhenScrolling = true
        loadNotes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.backgroundColor = selectedCategory?.color
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "NoteCell")
        if let note = notes?[indexPath.row] {
        
            cell.textLabel?.text = note.title

            if note.checked {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    //MARK: - Métodos de Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let note = notes?[indexPath.row]{
            do{
                try realm.write {
                     note.checked = !note.checked
                }
            } catch{
                print("Error al modificar la nota: \(error)")
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = (note.checked ? .checkmark : .none)
            tableView.deselectRow(at: indexPath, animated: true)
        }
       
    }
    
    //MARK: - Añadir nuevos ítems a la tabla
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let controller = UIAlertController(title: "Añadir nueva nota", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Añadir item", style: .default) { (action) in
            do{
                try self.realm.write {
                    let note = Note()
                    note.title = textField.text!
                    note.dateCreation = Date()
                    self.selectedCategory?.notes.append(note)
                    self.tableView.reloadData()
                }
            }catch{
                print("Error al guardar items \(error)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        controller.addAction(addAction)
        controller.addAction(cancelAction)
        
        controller.addTextField { (alertTextField) in
            alertTextField.placeholder = "Escribe aquí tu nota"
            textField = alertTextField
        }
        
        present(controller, animated: true, completion: nil)
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    
    //MARK: - Data persistence and manipulation
    
    
    func loadNotes(){
        notes = selectedCategory?.notes.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}


//MARK: - Métodos de la Search Bar

extension NotesTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        
        notes = selectedCategory?.notes.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreation", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadNotes()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - SwipeTableViewCellDelegate
extension NotesTableViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Borrar") { action, indexPath in
            // handle action by updating model with deletion
            if let noteToDelete = self.notes?[indexPath.row] {
                do{
                    try self.realm.write {
                        self.realm.delete(noteToDelete)
                        //self.tableView.reloadData()
                    }
                } catch{
                    print("Error al borrar la nota: \(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
}
