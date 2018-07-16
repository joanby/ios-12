//
//  DrawingImageView.swift
//  07-MathsTraining
//
//  Created by Juan Gabriel Gomila Salas on 11/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class DrawingImageView: UIImageView {

    weak var delegate : ViewController?
    var currentTouchPosition: CGPoint?
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }*/
    
    func draw(from start: CGPoint, to end: CGPoint){
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        
        self.image = renderer.image { ctx in
            self.image?.draw(in: self.bounds)
            
            //Definir los parámetros de dibujo de CGContext
            UIColor.purple.setStroke()
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineWidth(9)
            
            //Se dibuja una recta desde start hasta end
            ctx.cgContext.move(to: start)
            ctx.cgContext.addLine(to: end)
            ctx.cgContext.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.currentTouchPosition = touches.first?.location(in: self)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       super.touchesMoved(touches, with: event)
        
        guard let newTouchPoint = touches.first?.location(in: self) else {
            return
        }
        
        guard let previousTouchPoint = self.currentTouchPosition else {
            return
        }
        
        draw(from: previousTouchPoint, to: newTouchPoint)
        self.currentTouchPosition = newTouchPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.currentTouchPosition = nil
        
        perform(#selector(numberDrawnOnScreen), with: nil, afterDelay: 0.5)
    }
    
    
    @objc func numberDrawnOnScreen(){

        guard let image = self.image else {
            return
        }

        let drawRect = CGRect(x: 0, y: 0, width: 28, height: 28)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(bounds: drawRect, format: format)

        let imageWithWhiteBackground = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(bounds)
            image.draw(in: drawRect)
        }
        
        //Convertimos una UIImage de CG a CI
        let ciImage = CIImage(cgImage: imageWithWhiteBackground.cgImage!)
        
        //Hacemos una inversión de color para convertir fondo blanco en negro
        if let filter = CIFilter(name: "CIColorInvert"){
            //Define la CIImage como imagen a ser filtrada
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            //Contexto para llevar a cabo el filtro, la conversión
            let context = CIContext(options: nil)

            if let outputImage = filter.outputImage{
                //INtentamos hacer la creación a CGImage
                if let imageRef = context.createCGImage(outputImage, from: ciImage.extent){
                    //convertimos 'eso' a un objeto UIImage con el que poder procesar los resultados
                    let resultImage = UIImage(cgImage: imageRef)
                    //Finalmente le pasamos la imagen procesada a nuestro delegado
                    self.delegate?.numberDrawn(resultImage)
                }
            }
            
        }
    }

}
