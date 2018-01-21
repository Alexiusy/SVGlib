//
//  SVGParser.swift
//  iPet
//
//  Created by mac on 2017/10/26.
//  Copyright © 2017年 zeacone. All rights reserved.
//

import UIKit

// MARK: Document parser
class SVGDocumentParser: NSObject, XMLParserDelegate {
    
//    var stack = Stack<Node>()
//    var nodes = [Node]()
    
    /// Store all elements from parsed svg file.
    lazy var elements = [SVGElement]()
    
    /// Size of whole svg.
    var viewbox: CGSize!
    
    /// Store group transform
    var transform: String?
    
    
    func parse(_ fileName: String) {
        let data = try? Data.init(contentsOf: URL(fileURLWithPath: fileName))
        
        guard let newData = data else {
            return
        }
        
        let parser = XMLParser(data: newData)
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: Start parsing single element.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
//        let node = Node()
//        node.name = elementName
//        node.attr = attributeDict
//
//        stack.push(node)
//        nodes.append(node)
        
        switch elementName {
        case "svg":
            let width = (attributeDict["width"] as NSString?)?.doubleValue
            let height = (attributeDict["height"] as NSString?)?.doubleValue
            viewbox = CGSize(width: width!, height: height!)

        case "g":
            self.transform = attributeDict["transform"]

        case "path", "rect", "circle", "ellipse", "line", "polyline", "polygon":

            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let className = "\(namespace).SVG\(elementName.capitalized)"
            let ElementClass = NSClassFromString(className) as! SVGElement.Type
            let element: SVGElement? = ElementClass.init(attributeDict)

            if let newElement = element {
                newElement.transformString = self.transform
                elements.append(newElement)
            }

        default:
            print("Don't have any solutions for attribute \(elementName).")
        }
    }
    
    // MARK: Finish parsing single element.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "g" {
            self.transform = nil
        }

//        let tempNode = stack.pop()
//
//        if let top = stack.top() {
//            tempNode.parent = top
//            top.children.append(tempNode)
//        }
    }
    

}


// MARK: Transform parser
class SVGTransformParser: NSObject {
    
    class func numbers(_ str: String) -> [Double] {
        
        let scanner = Scanner(string: str)
        
        let skippedSet = CharacterSet(charactersIn: " ,\n")
        scanner.charactersToBeSkipped = skippedSet
        
        var numbers = [Double]()
        
        var number: Double = 0
        
        while scanner.scanDouble(&number) {
            numbers.append(number)
        }
        
        return numbers
    }
    
    class func transfrom(_ str: String) -> CGAffineTransform {
        
        var transform = CGAffineTransform.identity
        
        let scanner = Scanner(string: str)
        
        let skippedCharacter = CharacterSet(charactersIn: ",() ")
        
        scanner.charactersToBeSkipped = skippedCharacter
        
        while !scanner.isAtEnd {
            
            var string: NSString?
            if scanner.scanString("translate", into: &string) {
                var x: Double = 0
                var y: Double = 0
                scanner.scanDouble(&x)
                
                if !scanner.scanDouble(&y) { y = x }
                
                transform = transform.translatedBy(x: CGFloat(x), y: CGFloat(y))
                
            } else if scanner.scanString("scale", into: nil) {
                var scale: Double = 0
                scanner.scanDouble(&scale)
                transform = transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
                
            } else if scanner.scanString("rotate", into: nil) {
                var rotation: Double = 0
                scanner.scanDouble(&rotation)
                transform.rotated(by: radian(rotation))
                
            } else if scanner.scanString("matrix", into: nil) {
                var a: Double = 0
                var b: Double = 0
                var c: Double = 0
                var d: Double = 0
                var tx: Double = 0
                var ty: Double = 0
                
                scanner.scanDouble(&a)
                scanner.scanDouble(&b)
                scanner.scanDouble(&c)
                scanner.scanDouble(&d)
                scanner.scanDouble(&tx)
                scanner.scanDouble(&ty)
                transform = CGAffineTransform(a: CGFloat(a), b: CGFloat(b), c: CGFloat(c), d: CGFloat(d), tx: CGFloat(tx), ty: CGFloat(ty))
                
            } else {
                scanner.scanLocation = str.count
            }
        }
        
        return transform
    }
    
    // Convert angle to radian.
    class func radian(_ angle: Double) -> CGFloat {
        return CGFloat(angle / 180 * Double.pi)
    }
}
