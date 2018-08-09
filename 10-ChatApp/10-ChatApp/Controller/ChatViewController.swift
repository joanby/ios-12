//
//  ChatViewController.swift
//  10-ChatApp
//
//  Created by Juan Gabriel Gomila Salas on 06/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textBoxHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        self.messageTextField.delegate = self

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMessageZone))
        self.messagesTableView.addGestureRecognizer(tapGesture)
        
        
        self.messagesTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCellID")
        self.messagesTableView.separatorStyle = .none
        
        configureTableView()
        retrieveMessagesFromFirebase()
    }
    
    //Establece el tamaño correcto para cada una de las celdas de la tabla
    func configureTableView() {
        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.estimatedRowHeight = 120
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /*
     MARK: - Firebase Methods
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
        self.messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDict = ["sender": Auth.auth().currentUser?.email,
                           "body" : self.messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messageDict) { (error, ref) in
            if error != nil {
                print(error!)
            } else {
                print("Mensaje guardado correctamente")
                
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextField.text = ""
            }
        }
        
    }
    
    //Establecemos un observador del evento .childAdded de la base de datos Messages de Firebase para saber cuando se añade un nuevo
    //mensaje a dicha table del servidor.
    func retrieveMessagesFromFirebase(){
        let messagesDB = Database.database().reference().child("Messages")
        messagesDB.observe(.childAdded) { (snapshot) in
            let snpValue = snapshot.value as! Dictionary<String, String>
            
            let sender = snpValue["sender"]!
            let body = snpValue["body"]!
            
            let message = Message(sender: sender, body: body)
            self.messagesArray.append(message)
            
            self.configureTableView()
            self.messagesTableView.reloadData()
        }
        
        
    }
    
    
    
    /*MARK: - UITableViewDataSource */
    var messagesArray : [Message]  = [Message]()

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
        cell.messageImageView.image = UIImage(named: "avatar")
        
        if cell.usernameLabel.text == Auth.auth().currentUser?.email {
            cell.messageImageView.backgroundColor = UIColor.flatLime()
            cell.nessageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else {
            cell.messageImageView.backgroundColor = UIColor.flatWatermelon()
            cell.nessageBackground.backgroundColor = UIColor.flatGray()
        }
        
        
        return cell
    }
    
    
    /*MARK: - UITextFieldDelegate Methods*/
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.textBoxHeight.constant = 80 + 50 + 258
            self.view.layoutIfNeeded()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideMessageZone()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @objc func hideMessageZone(){
        self.messageTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.textBoxHeight.constant = 80
            self.view.layoutIfNeeded()
        }
    }
    
}
