//
//  ChatViewController.swift
//  10-ChatApp
//
//  Created by Juan Gabriel Gomila Salas on 06/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        
        
        self.messagesTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCellID")
        
        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.estimatedRowHeight = 120
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logoutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch {
            print("Error: no se ha podido hacer un sign out")
        }
        
        
        guard navigationController?.popToRootViewController(animated: true) != nil else {
            print("No hay view controllers que eliminar de la stack")
            return
        }
        
        
    }
    @IBAction func sendPressed(_ sender: UIButton) {
    
    }
    
    
    
    /*MARK: - UITableViewDataSource */
    let messagesArray : [Message]  = [
        Message(), Message(), Message(), Message()
    ]

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCellID", for: indexPath) as! MessageCell
        
        cell.usernameLabel.text = messagesArray[indexPath.row].sender
        cell.messageLabel.text = messagesArray[indexPath.row].body
        return cell
    }
    
    
}
