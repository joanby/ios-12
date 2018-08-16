//
//  NewCategoryViewController.swift
//  11-NotesOnTheGo
//
//  Created by Juan Gabriel Gomila Salas on 15/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import RealmSwift

class NewCategoryViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!

    @IBOutlet var colorSliders: [UISlider]!
    
    @IBOutlet var colorLabels: [UILabel]!
    
    @IBOutlet weak var hexLabel: UILabel!
    
    let colorKeys = ["R","G","B","A"]
    
    let imagePicker = UIImagePickerController()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Como la image view no puede invocar a IBActions, le añadimos un gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

        repaintBackground()
        
        imagePicker.delegate = self
    }
    

    @IBAction func sliderMoved(_ sender: UISlider) {
        
        colorLabels[sender.tag].text = "\(colorKeys[sender.tag]): \(lroundf(sender.value*255.0))"
        repaintBackground()
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        let category = Category()
        category.title = textField.text!
        category.colorHex = UIColor(hex: hexLabel.text!)?.toHex
        category.image = imageView.image?.pngData()
        //TODO: guardar o bien imágen más pequeña o bien URL de su ubicación exacta
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error al guardar la categoría en CD")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageViewTapped(){
        

        let controller = UIAlertController(title: "Selecciona una imagen", message: "", preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Cámara de fotos", style: .default, handler: { (alert) in
            self.presentImagePicker(with: .camera)
        }))
        controller.addAction(UIAlertAction(title: "Álbum de Fotos", style: .default, handler: { (action) in
           self.presentImagePicker()
        }))
        controller.addAction(UIAlertAction(title: "Carrete de Fotos", style: .default, handler: { (action) in
            self.presentImagePicker(with: .photoLibrary)
        }))
        self.present(controller, animated: true, completion: nil)
       
    }
    
    func presentImagePicker(with sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func repaintBackground(){
        let backColor = UIColor(red: CGFloat(colorSliders[0].value), green: CGFloat(colorSliders[1].value), blue: CGFloat(colorSliders[2].value), alpha: CGFloat(colorSliders[3].value))
        self.view.backgroundColor = backColor
        self.hexLabel.text = backColor.toHex
    }

}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
