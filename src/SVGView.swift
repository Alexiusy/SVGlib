//
//  SVGView.swift
//  iPet
//
//  Created by Zeacone on 2017/11/13.
//  Copyright © 2017年 zeacone. All rights reserved.
//

import UIKit

private var clickableKey: Void?

extension CAShapeLayer {
    var clickable: Bool {
        get {
            return objc_getAssociatedObject(self, &clickableKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &clickableKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}


class SVGView: UIView {
    
    func parse(_ filepath: String) -> SVGView {
        self.parseSVG(filepath)
        return self
    }
    
    func parseSVG(_ filepath: String) {
        let parser = SVGDocumentParser()
        parser.parse(filepath)
        
        let size = parser.viewbox!
        let elements = parser.elements
        
        self.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        self.drawSVG(elements)
    }
    
    func drawSVG(_ elements: [SVGElement]) {
        
        for element in elements {
            
            let shape = CAShapeLayer()
            shape.path = element.path.cgPath
            shape.clickable = element.clickable
            shape.lineWidth = 1
            shape.strokeColor = element.strokeColor?.cgColor
            shape.fillColor = element.fillColor?.cgColor
            
            shape.shadowColor = UIColor.lightGray.cgColor
            shape.shadowPath = shape.path
            shape.shadowRadius = 0.1
            shape.shadowOpacity = 0.4
            shape.shadowOffset = .zero
            
            self.layer.addSublayer(shape)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.clicked((touches.first?.location(in: self))!)
    }
    
    var overlay = CAShapeLayer()
    
    func clicked(_ touchPoint: CGPoint) {
        
        overlay.removeFromSuperlayer()
        
        self.layer.sublayers?.forEach({ (layer) in
            let shape = layer as! CAShapeLayer
            
            let path = UIBezierPath(cgPath: shape.path!)
            
            if (path.contains(touchPoint) && shape.clickable) {
                overlay.path = path.cgPath
                self.layer.addSublayer(overlay)
            }
        })
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
