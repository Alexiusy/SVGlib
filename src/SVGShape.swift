//
//  SVGShape.swift
//  iPet
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 zeacone. All rights reserved.
//

import UIKit


/// A line.
/// It has four attribute(start point: x1, y1; end point: x2, y2)
class SVGLine: SVGElement {
    
    override func draw(attr: [String : String]) {
        
        let optX1 = (attr["x1"] as NSString?)?.doubleValue
        let optY1 = (attr["y1"] as NSString?)?.doubleValue
        let optX2 = (attr["x2"] as NSString?)?.doubleValue
        let optY2 = (attr["y2"] as NSString?)?.doubleValue
        
        guard let x1 = optX1, let y1 = optY1, let x2 = optX2, let y2 = optY2 else { return }
        
        let p1 = CGPoint(x: x1, y: y1)
        let p2 = CGPoint(x: x2, y: y2)
        
        self.path.move(to: p1)
        self.path.addLine(to: p2)
    }
}


/// A rectangle.
/// It has four attribute(origin: x, y; size: width, height)
class SVGRect: SVGElement {
    
    override func draw(attr: [String : String]) {
        
        let optX = (attr["x"] as NSString?)?.doubleValue
        let optY = (attr["y"] as NSString?)?.doubleValue
        let optW = (attr["width"] as NSString?)?.doubleValue
        let optH = (attr["height"] as NSString?)?.doubleValue
        
        guard let x = optX, let y = optY, let width = optW, let height = optH else { return }
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        self.path = UIBezierPath(rect: rect)
        
        if self.id == "background" {
            self.clickable = false
        }
    }
}


/// A circle.
class SVGCircle: SVGElement {
    
    override func draw(attr: [String : String]) {
        
        let optCx = (attr["cx"] as NSString?)?.doubleValue
        let optCy = (attr["cy"] as NSString?)?.doubleValue
        let optR = (attr["r"] as NSString?)?.doubleValue
        
        guard let cx = optCx, let cy = optCy, let r = optR else { return }
        
        let center = CGPoint(x: cx, y: cy)
        
        self.path.addArc(withCenter: center, radius: CGFloat(r), startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        
        self.clickable = true
    }
}


/// An ellipse
class SVGEllipse: SVGElement {
    
    override func draw(attr: [String : String]) {
        
        let optCx = (attr["cx"] as NSString?)?.doubleValue
        let optCy = (attr["cy"] as NSString?)?.doubleValue
        let optRx = (attr["rx"] as NSString?)?.doubleValue
        let optRy = (attr["ry"] as NSString?)?.doubleValue
        
        guard let cx = optCx, let cy = optCy, let rx = optRx, let ry = optRy else { return }
        
        let rect = CGRect(x: cx-rx, y: cy-ry, width: rx*2, height: ry*2)
        
        self.path = UIBezierPath(ovalIn: rect)
        
        self.clickable = true
    }
}


/// Polyline
class SVGPolyline: SVGElement {
    
    override func draw(attr: [String : String]) {
        
        let optPoints = attr["points"]
        
        guard let points = optPoints else { return }
        
        let numbers = SVGTransformParser.numbers(points)
        
        for i in 0..<numbers.count/2 {
            let point = CGPoint(x: numbers[i*2], y: numbers[i*2+1])
            
            if i == 0 {
                self.path.move(to: point)
            } else {
                self.path.addLine(to: point)
            }
        }
    }
}


/// Polygon
class SVGPolygon: SVGElement {
    
    override func draw(attr: [String : String]) {
        
        let optPoints = attr["points"]
        
        guard let points = optPoints else { return }
        
        let numbers = SVGTransformParser.numbers(points)
        
        for i in 0..<numbers.count/2 {
            let point = CGPoint(x: numbers[i*2], y: numbers[i*2+1])
            
            if i == 0 {
                self.path.move(to: point)
            } else {
                self.path.addLine(to: point)
            }
        }
        
        self.path.close()
        
        if self.id == "background" {
            self.clickable = false
        }
    }
    
}
