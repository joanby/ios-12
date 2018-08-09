//
//  ViewController.swift
//  09-EyesInvaders
//
//  Created by Juan Gabriel Gomila Salas on 19/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let face = SCNNode()
    let leftEye = Eye(color: .green)
    let rightEye = Eye(color: .yellow)
    
    let phonePlane = SCNNode(geometry: SCNPlane(width: 1, height: 1))
    
    let aimImageView = UIImageView(image: UIImage(named: "aim")!)
    var targets = [UIImageView]()
    var currentTarget = 0
    
    let numberOfSmoothUpdates = 25
    var eyeGazeHistory = ArraySlice<CGPoint>()
    
    let targetNames = ["alien-blue", "alien-red", "alien-green", "alien-orange"]
    
    var laserShot: AVAudioPlayer?
    
    var startTime = CACurrentMediaTime()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        sceneView.scene.rootNode.addChildNode(face)
        face.addChildNode(leftEye)
        face.addChildNode(rightEye)
        
        sceneView.scene.rootNode.addChildNode(phonePlane)
        
        aimImageView.frame = CGRect(x:UIScreen.main.bounds.midX, y:UIScreen.main.bounds.midY, width:64, height:64)
        self.view.addSubview(aimImageView)
        
        initializeTargets()
        
        perform(#selector(createTarget), with: nil, afterDelay: 3.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            print("No se soporta el tracking de caras...")
            return
        }
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func initializeTargets(){
        let rowStackView = UIStackView()
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        rowStackView.distribution = .fillEqually
        rowStackView.axis = .vertical
        rowStackView.spacing = 20
        
        for _ in 1...8 {
            let colStackView = UIStackView()
            colStackView.translatesAutoresizingMaskIntoConstraints = false
            
            colStackView.distribution = .fillEqually
            colStackView.axis = .horizontal
            colStackView.spacing = 20
            
            rowStackView.addArrangedSubview(colStackView)
            
            for imageName in targetNames {
                let imageView = UIImageView(image: UIImage(named:imageName))
                imageView.contentMode = .scaleAspectFit
                imageView.alpha = 0
                targets.append(imageView)
                
                colStackView.addArrangedSubview(imageView)
            }
        }
        
        self.view.addSubview(rowStackView)
        
        NSLayoutConstraint.activate([
            rowStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rowStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rowStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            rowStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
            ])
        
        self.view.bringSubviewToFront(aimImageView)
        
        targets.shuffle()
    }
    
    @objc func createTarget(){
        
        guard currentTarget < self.targets.count else {
            endGame()
            return
        }
        //Objetivo actual que queremos mostrar por pantalla
        let target = self.targets[currentTarget]
        target.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.5) {
            target.transform = .identity
            target.alpha = 1
        }
        currentTarget += 1
    }
    
    func shoot(){
        let aimFrame = aimImageView.superview!.convert(aimImageView.frame, to: nil)
        
        let hitTargets = self.targets.filter { iv -> Bool in
            if iv.alpha == 0 { return false }
            let targetFrame = iv.superview!.convert(iv.frame, to: nil)
            
            return targetFrame.intersects(aimFrame)
        }
        
        guard let selectedTarget = hitTargets.first else {
            return
        }
        
        selectedTarget.alpha = 0
        
        if let url = Bundle.main.url(forResource: "laser-sound", withExtension: "wav") {
            laserShot = try? AVAudioPlayer(contentsOf: url)
            laserShot?.play()
        }
        
        perform(#selector(createTarget), with: nil, afterDelay: 1.5)
    }
    

    func update(using anchor: ARFaceAnchor){
        
        if let leftBlink = anchor.blendShapes[.eyeBlinkLeft] as? Float,
            let rightBlink = anchor.blendShapes[.eyeBlinkRight] as? Float {
            //Si tenemos evidencias de que ambos ojos parpaean más de un 20%, disparamos y listo
            if leftBlink > 0.2 && rightBlink > 0.2 {
                shoot()
                return
            }
        }
        
        
        leftEye.simdTransform = anchor.leftEyeTransform
        rightEye.simdTransform = anchor.rightEyeTransform
        
        let intersectPoints = [leftEye, rightEye].compactMap { eye -> CGPoint? in
            let hitTest = self.phonePlane.hitTestWithSegment(from: eye.target.worldPosition, to: eye.worldPosition)
            return hitTest.first?.screenPosition
        }
        
        print("PUNTOS DE INTERSECCIÓN: \(intersectPoints)")
        
        guard let leftPoint = intersectPoints.first, let rightPoint = intersectPoints.last else { return }
        
        let centerPoint = CGPoint(x: (leftPoint.x + rightPoint.x)/2, y: -(leftPoint.y + rightPoint.y)/2)
      
        eyeGazeHistory.append(centerPoint)
        //Añadido eyeGazeHistory = ... debido a que el método suffix devuelve la colección con el número de elementos, en lugar de cambiar el tamaño del objeto original.
        eyeGazeHistory = eyeGazeHistory.suffix(numberOfSmoothUpdates)
        
        aimImageView.transform = eyeGazeHistory.averageAffineTransform
        
    }
    
    // MARK: - ARSessionDelegate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        DispatchQueue.main.async {
            self.face.simdTransform = node.simdTransform
            self.update(using: faceAnchor)
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView?.simdTransform else { return }
        
        self.phonePlane.simdTransform = pointOfView
    }
    
    
    
    func endGame(){
        let gameTime = Int(CACurrentMediaTime() - startTime)
        let alertController = UIAlertController(title: "Fin de la partida", message: "Has tardado \(gameTime) segundos.", preferredStyle: .alert)
        present(alertController, animated: true)
        
        perform(#selector(backToMainMenu), with: nil, afterDelay: 4.0)
    }
    
    @objc func backToMainMenu(){
        dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}


extension SCNHitTestResult{
    var screenPosition : CGPoint{
        //Aquí va el cálculo de la colisión
        
        let physicalIphoneXSize = CGSize(width: 0.062/2, height: 0.135/2)
        
        let sizeResolution = UIScreen.main.bounds.size
        
        let screenX = CGFloat(localCoordinates.x) / physicalIphoneXSize.width * sizeResolution.width
        
        let screenY = CGFloat(localCoordinates.y) / physicalIphoneXSize.height * sizeResolution.height
        
        return CGPoint(x: screenX, y: screenY)
        
    }
}

extension Collection where Element == CGPoint{
    var averageAffineTransform : CGAffineTransform {
        var x : CGFloat = 0
        var y : CGFloat = 0
        
        for item in self{
            x += item.x
            y += item.y
        }
        
        let elementCount = CGFloat(self.count)
        return CGAffineTransform(translationX: x/elementCount, y: y/elementCount)
    }
}
