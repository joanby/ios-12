//
//  NotesTableViewController.swift
//  11-NotesOnTheGo
//
//  Created by Juan Gabriel Gomila Salas on 12/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {
    
    var notesArray = [Note]()
    var selectedCategory : Category?{
        didSet{
            loadNotes()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Notes.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        return notesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "NoteCell")
        let note = notesArray[indexPath.row]
        
        cell.textLabel?.text = note.title
        
        if note.checked {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: - Métodos de Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(notesArray[indexPath.row])
        
        let note = notesArray[indexPath.row]
        note.checked = (note.checked ? false : true)
        
        /* MARK: - Borrado de Core Data
         context.delete(notesArray[indexPath.row])
        notesArray.remove(at: indexPath.row)
        */
        
        persistNotes()
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = (note.checked ? .checkmark : .none)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Añadir nuevos ítems a la tabla
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let controller = UIAlertController(title: "Añadir nueva nota", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Añadir item", style: .default) { (action) in
            //TODO: Recuperar lo que haya escrito el usuario en el textfield cuando pulsa el botón Añadir
            let note = Note(context: self.context)
            note.title = textField.text!
            note.parentCategory = self.selectedCategory
            self.notesArray.append(note)
            self.persistNotes()
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
    
    
    //MARK: - Data persistence and manipulation
    func persistNotes() {
        /*let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.notesArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error al codificar y guardar el array:\(error)")
        }*/
        
        do{
            try context.save()
        }catch{
            print("Error al intentar guardar el contexto: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadNotes(from request: NSFetchRequest<Note> = Note.fetchRequest(), predicate: NSPredicate? = nil){
        /*if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            do{
                notesArray = try decoder.decode([Note].self, from: data)
            }catch{
                print("Error descodificando el array de notas \(error)")
            }
        }*/
        
        let categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedCategory!.title!)

        if let previousPredicte = predicate{
            //aquí tenemos un predicado de búsqueda previo
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [previousPredicte, categoryPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            notesArray = try context.fetch(request)
        } catch {
            print("Error al recuperar datos de Core Data \(error)")
        }
        
        tableView.reloadData()
    }
    
}


//MARK: - Métodos de la Search Bar
extension NotesTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        
        let sortDescription = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescription]
        
        loadNotes(from: request, predicate: predicate)
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
