//
//  ViewController.swift
//  13-ARithmetics
//
//  Created by Juan Gabriel Gomila Salas on 04/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


enum MathOperations: CaseIterable {
    case add, substract, multiply, divide
}

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctImageView: UIImageView!
    
    var correctAnswer : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        askQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Numbers", bundle: nil) else {
            fatalError("No se han podido cargar las imagenes para AR... ")
        }
        
        configuration.trackingImages = trackingImages
        
        configuration.maximumNumberOfTrackedImages = 2
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.4)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        
        
        let node = SCNNode()
        node.addChildNode(planeNode)
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    //MARK: Game Methods
    func createNewQuestion() -> (question: String, answer : Int){
        
        let operation = MathOperations.allCases.randomElement()!
        var question : String
        var answer : Int
        
        repeat{
            
            switch operation {
            case .add:
                let x = Int.random(in: 1...49)
                let y = Int.random(in: 1...49)
                question = "\(x) + \(y) = ?"
                answer = x + y
            case .substract:
                let x = Int.random(in: 1...49)
                let y = Int.random(in: 1...49)
                question = "\(x+y) - \(x)"
                answer = y
            case .multiply:
                let x = Int.random(in: 1...10)
                let y = Int.random(in: 1...9)
                question = "\(x) x \(y) = ?"
                answer = x*y
             case .divide:
                let x = Int.random(in: 1...10)
                let y = Int.random(in: 1...9)
                question = "\(x*y) / \(x)"
                answer = y
            }
            
        } while !answer.hasUniqueDigits
        
        return (question, answer)
    }
    
    func askQuestion(){
        let newQuestion = createNewQuestion()
        questionLabel.text = newQuestion.question
        correctAnswer = newQuestion.answer
        
        questionLabel.alpha = 0
        
        UIView.animate(withDuration: 0.7) {
            
            self.questionLabel.alpha = 1.0
            
            self.correctImageView.alpha = 0.0
            self.correctImageView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            
        }
    }
    
    func showCorrectAnswer() {
        correctImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        UIView.animate(withDuration: 0.7) {
            self.correctImageView.transform = .identity
            self.correctImageView.alpha = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.askQuestion()
        }
    }
    
    //Update de Scene Kit -> se llama a cada frame de actualización
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Obtener la lista de anclas que hay actualmente en la pantalla
        guard let anchors = sceneView.session.currentFrame?.anchors else { return }
        
        //Filtrar las anclas que son imagenes y eliminar las que no sean imágenes o las que no están en un grupo de ARKit
        let visibleAnchors = anchors.filter {
            guard let anchor = $0 as? ARImageAnchor else{ return false }
            return anchor.isTracked
        }
        
        //Ordenar la lista de anclas / imagenes visibles de izquierda a derecha por su posición en X (izquierda < derecha)
        let nodes = visibleAnchors.sorted { (anchor1, anchor2) -> Bool in
            guard let node1 = sceneView.node(for: anchor1) else { return false }
            guard let node2 = sceneView.node(for: anchor2) else { return false }
            return node1.worldPosition.x < node2.worldPosition.x
        }
        
        //De las imágenes extraeremos sus nombres y de ahí los números para juntarlos en un String
        let strAnswer = nodes.reduce("") { $0 + ($1.name ?? "") }
        //""
        //"" + "5" = "5"
        //"5" + "7" = "57"
        
        //Convertiremos el string a entero
        let userAnswer = Int(strAnswer) ?? 0
        
        //Comprobaremos si el número entero proporcionado coincide o no con correctAnswer para llamar (o no) al método showCorrectAnswer
        if userAnswer == correctAnswer{
            //Anulamos la respuesta actual para evitar problemas en el próximo frame
            correctAnswer = nil
            //Traemos el check verde
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showCorrectAnswer()
            }
        }
    }
    
}
