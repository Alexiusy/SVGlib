//
//  SVGElement.swift
//  iPet
//
//  Created by mac on 2017/10/26.
//  Copyright © 2017年 zeacone. All rights reserved.
//

import UIKit

struct Stack<T> {
    var items = [T]()
    
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    func top() -> T? {
        return items.last
    }
}

class SVGElement: NSObject {

    // Element's parent
    var parent: SVGElement?
    
    // Element's children
    var children = [SVGElement]()
    
    // Element's name
    var name: String!
    
    /// Element's id to find this element easily.
    var id: String?
    
    var fillRule: String?
    
    var transform: CGAffineTransform?
    
    /// Element's title. If this property is not nil, then we should show a text element on it.
    var title: String?
    
    /// A bezier path to draw element.
    lazy var path: UIBezierPath = UIBezierPath()
    
    /// Stroke color
    var strokeColor: UIColor?
    
    /// Fill color
    var fillColor: UIColor?
    
    /// A property to decide if this element is selectable.
    var clickable: Bool = false
    
    /// A transform string to generate real transform.
    var transformString: String? {
        get {
            return nil
        }
        set {
            if let value = newValue {
                let transform = SVGTransformParser.transfrom(value)
                self.path.apply(transform)
            }
        }
    }
    
    /// I don't know how this works.
    var className: String?
    
    
    /// Initializer
    ///
    /// - Parameter attr: Some properties.
    required init(_ attr: [String: String]) {
        super.init()
        self.readProperty(attr)
        self.draw(attr: attr)
    }
    
    
    /// Read some public properties from attribute collections.
    ///
    /// - Parameter attr: Some properties.
    func readProperty(_ attr: [String: String]) {
        
        self.title = attr["title"]
        
        self.id = attr["id"]
        
        self.strokeColor = self.hexColorString(attr["stroke"])
        
        self.fillColor = self.hexColorString(attr["fill"])

        self.transformString = attr["transform"]
        
        self.className = attr["class"]
    }
    
    
    /// Convert hex string to UIColor.
    ///
    /// - Parameter hex: A hex string.
    /// - Returns: Destination color.
    func hexColorString(_ hex: String?) -> UIColor {
        
        guard var string = hex else { return UIColor.clear }
        
        if string.hasPrefix("#") {
            string.removeFirst(1)
        }

        if string.hasPrefix("0x") {
            string.removeFirst(2)
        }
        
        let scanner = Scanner(string: string)
        
        var hexColor: UInt32 = 0
        if scanner.scanHexInt32(&hexColor) {
            return self.hexColor(Int(hexColor))
        }
        return UIColor.clear
    }
    
    
    /// Parse color from a hex integer.
    ///
    /// - Parameter hex: A hex integer.
    /// - Returns: Destination color.
    func hexColor(_ hex: Int) -> UIColor {
        let red = CGFloat(hex >> 16 & 0xFF) / 255.0
        let green = CGFloat(hex >> 8 & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    /// Provide a super function but do nothing. It will be implemented by it's subclass.
    ///
    /// - Parameter attr: Some properties.
    func draw(attr: [String: String]) {
        
    }
    
}


