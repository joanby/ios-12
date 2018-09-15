//
//  ViewController.swift
//  14-ARMuseums
//
//  Created by Juan Gabriel Gomila Salas on 07/09/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var paintings = [String:Paiting]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
    
        self.loadPaintingsData()
        
        self.preloadWebView()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Paintings", bundle: nil) else {
            fatalError("No se han podido cargar las imágenes de AR")
        }
        configuration.trackingImages = trackingImages
        
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
        
        guard let paitingName = imageAnchor.referenceImage.name else { return nil }
        
        guard let painting = paintings[paitingName] else { return nil }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear

        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2

        
        
        let node = SCNNode()
        node.opacity = 0
        node.addChildNode(planeNode)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            SCNTransaction.animationDuration = 1
            node.opacity = 1
        }
        
        let spacing: Float = 0.01
        
        let titleNode = textNode(for: painting.title, font: UIFont.boldSystemFont(ofSize: 10))
        titleNode.pivotToTopLeft()
        titleNode.position.x += Float(plane.width/2) + spacing
        titleNode.position.y += Float(plane.height/2)
        titleNode.opacity = 1
        planeNode.addChildNode(titleNode)
        
        let artistNode = textNode(for: painting.artist, font: UIFont.systemFont(ofSize: 7))
        artistNode.pivotToTopCenter()
        artistNode.position.y -= Float(plane.height/2) + spacing
        planeNode.addChildNode(artistNode)
        
        let yearNode = textNode(for: painting.year, font: UIFont.systemFont(ofSize: 6))
        yearNode.pivotToTopCenter()
        yearNode.position.y = artistNode.position.y - spacing - artistNode.height
        planeNode.addChildNode(yearNode)
        
        let webWidth = CGFloat(max(titleNode.width, 0.25))
        let webHeight = CGFloat((Float(plane.height) - titleNode.height) + spacing + artistNode.height  + spacing + yearNode.height)
        
        let webPlane = SCNPlane(width: webWidth, height: webHeight)
        let webNode = SCNNode(geometry: webPlane)
        webNode.pivotToTopLeft()
        webNode.position.x += Float(plane.width/2) + spacing
        webNode.position.y = titleNode.position.y - titleNode.height - spacing
        planeNode.addChildNode(webNode)
        
        DispatchQueue.main.async {
            let width: CGFloat = 800
            let height = width / (webWidth / webHeight)
            
            let webView = UIWebView(frame: CGRect(x:0, y:0, width: width, height: height))
            let request = URLRequest(url: URL(string: painting.url)!)
            webView.loadRequest(request)
            webPlane.firstMaterial?.diffuse.contents = webView
        }
        
        return node
    }
    
    func textNode(for str: String, font: UIFont) -> SCNNode{
        let text = SCNText(string: str, extrusionDepth: 0.0)
        text.flatness = 0.1
        text.font = font
        
        let node = SCNNode(geometry: text)
        node.scale = SCNVector3(0.002, 0.002, 0.002)
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
    
    //MARK: Manage data
    func loadPaintingsData(){
        guard let url = Bundle.main.url(forResource: "paintings", withExtension: "json") else {
            fatalError("No hemos podido localizar la información de los cuadros...")
        }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            fatalError("No se ha podido leer la información del JSON")
        }
        
        let jsonDecorder = JSONDecoder()
        guard let decodedPaitings = try? jsonDecorder.decode([String:Paiting].self, from: jsonData) else {
            fatalError("Problemas al procesar el fichero JSON")
        }
        
        self.paintings = decodedPaitings
    }
    
    func preloadWebView(){
        let preload = UIWebView()
        self.view.addSubview(preload)
        let request = URLRequest(url: URL(string:"https://es.wikipedia.org/wiki/La_balsa_de_la_Medusa")!)
        preload.loadRequest(request)
        preload.removeFromSuperview()
    }
}
