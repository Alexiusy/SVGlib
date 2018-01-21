//
//  SVGPath.swift
//  iPet
//
//  Created by mac on 2017/10/27.
//  Copyright © 2017年 zeacone. All rights reserved.
//

import UIKit

class SVGPath: SVGElement {
    
    var c_pre = CGPoint.zero
    
    var q_pre = CGPoint.zero
    
    var end = CGPoint.zero
    
    override func draw(attr: [String : String]) {
        
        let commandStr = attr["d"]
        
        guard let command = commandStr else { return }
        
        let skippedSet = CharacterSet(charactersIn: " ,\n")
        let commandSet = CharacterSet(charactersIn: "MLACQSTHVZmlacqsthvz")
        
        let scanner = Scanner(string: command)
        scanner.charactersToBeSkipped = skippedSet
        
        var cmd: NSString?
        
        while scanner.scanCharacters(from: commandSet, into: &cmd) {
            // There is a sitution that command z and command m may close together.
            // Then the command actually is zm, and there is no way to handle command zm,
            // so it should be separated.
            if cmd?.length == 2 {
                self.close()
                cmd = cmd?.substring(from: 1) as NSString?
            }
            
            var numbers = [Double]()
            
            var number: Double = 0
            
            while scanner.scanDouble(&number) {
                numbers.append(number)
            }
            // Execute drawing with command and numbers
            execute(cmd, numbers)
        }
    }
    
    func execute(_ cmd: NSString?, _ numbers: [Double]) {
        
        guard let command = cmd else { return }
        
        switch command {
        case "M", "m":
            move(numbers, relative: cmd=="m")
            
        case "L", "l":
            addLine(numbers, relative: cmd=="l")
            
        case "A", "a":
            addArc(numbers, relative: cmd=="a")
            
        case "C", "c":
            addCurve(numbers, relative: cmd=="c")
            
        case "Q", "q":
            addQuad(numbers, relative: cmd=="q")
            
        case "S", "s":
            addReplicatedCurve(numbers, cmd=="s")
            
        case "T", "t":
            addReplicatedQuad(numbers, cmd=="t")
            
        case "H", "h":
            addHorizion(numbers, relative: cmd=="h")
            
        case "V", "v":
            addVertical(numbers, relative: cmd=="v")
            
        case "Z", "z":
            close()
            
        default:
            print("Don't have any solutions for cmd \(command).")
        }
    }
    
    func move(_ numbers: [Double], relative: Bool) {
        for i in 0..<numbers.count/2 {
            var point = CGPoint(x: numbers[i*2], y: numbers[i*2+1])
            if relative {
                point = CGPoint(x: point.x+end.x, y: point.y+end.y)
            }
            self.path.move(to: point)
            end = point
        }
    }
    
    func addLine(_ numbers: [Double], relative: Bool) {
        for i in 0..<numbers.count/2 {
            var point = CGPoint(x: numbers[i*2], y: numbers[i*2+1])
            if relative {
                point = CGPoint(x: point.x+end.x, y: point.y+end.y)
            }
            self.path.addLine(to: point)
            end = point
        }
    }
    
    func addArc(_ numbers: [Double], relative: Bool) {
        
    }
    
    func addCurve(_ numbers: [Double], relative: Bool) {
        for i in 0..<numbers.count/6 {
            var c1 = CGPoint(x: numbers[i*6], y: numbers[i*6+1])
            var c2 = CGPoint(x: numbers[i*6+2], y: numbers[i*6+3])
            var point = CGPoint(x: numbers[i*6+4], y: numbers[i*6+5])
            
            if relative {
                c1 = CGPoint(x: c1.x+end.x, y: c1.y+end.y)
                c2 = CGPoint(x: c2.x+end.x, y: c2.y+end.y)
                point = CGPoint(x: point.x+end.x, y: point.y+end.y)
            }
            
            self.path.addCurve(to: point, controlPoint1: c1, controlPoint2: c2)
            
            end = point
            c_pre = c2
        }
    }
    
    func addQuad(_ numbers: [Double], relative: Bool) {
        for i in 0..<numbers.count/4 {
            var c = CGPoint(x: numbers[i*4], y: numbers[i*4+1])
            var point = CGPoint(x: numbers[i*4+2], y: numbers[i*4+3])
            
            if relative {
                c = CGPoint(x: c.x+end.x, y: c.y+end.y)
                point = CGPoint(x: point.x+end.x, y: point.y+end.y)
            }
            
            self.path.addQuadCurve(to: point, controlPoint: c)
            
            end = point
            q_pre = c
        }
    }
    
    func addReplicatedCurve(_ numbers: [Double], _ relative: Bool) {
        for i in 0..<numbers.count/4 {
            var c1: CGPoint
            var c2 = CGPoint(x: numbers[i*4], y: numbers[i*4+1])
            var point = CGPoint(x: numbers[i*4+2], y: numbers[i*4+3])
            
            if relative {
                c2 = CGPoint(x: c2.x+end.x, y: c2.y+end.y)
                point = CGPoint(x: point.x+end.x, y: point.y+end.y)
            }
            
            if c_pre.equalTo(.zero) {
                c1 = c2
            } else {
                c1 = CGPoint(x: end.x+(end.x-c_pre.x), y: end.y+(end.y-c_pre.y))
            }
            self.path.addCurve(to: point, controlPoint1: c1, controlPoint2: c2)
            
            end = point
            c_pre = c2
        }
    }
    
    func addReplicatedQuad(_ numbers: [Double], _ relative: Bool) {
        for i in 0..<numbers.count/2 {
            var point = CGPoint(x: numbers[i*2], y: numbers[i*2+1])
            var c: CGPoint
            
            if relative {
                point = CGPoint(x: end.x+point.x, y: end.y+point.y)
            }
            
            if q_pre.equalTo(.zero) {
                c = point
            } else {
                c = CGPoint(x: end.x+(end.x-q_pre.x), y: end.y+(end.y-q_pre.y))
            }
            self.path.addQuadCurve(to: point, controlPoint: c)
            
            end = point
            q_pre = c
        }
    }
    
    func addHorizion(_ numbers: [Double], relative: Bool) {
        for number in numbers {
            var point = CGPoint(x: CGFloat(number), y: end.y)
            
            if relative {
                point = CGPoint(x: end.x+point.x, y: end.y)
            }
            self.path.addLine(to: point)
            
            end = point
        }
    }
    
    func addVertical(_ numbers: [Double], relative: Bool) {
        for number in numbers {
            
            var point = CGPoint(x: end.x, y: CGFloat(number));
            
            if (relative) {
                point = CGPoint(x: end.x, y: end.y+point.y);
            }
            self.path.addLine(to: point)
            
            end = point
        }
    }
    
    func close() {
        self.path.close()
        self.clickable = true
    }
}


