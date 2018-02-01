//
//  Node.swift
//  iPet
//
//  Created by Zeacone on 2018/1/21.
//  Copyright © 2018年 zeacone. All rights reserved.
//

import UIKit

class Node {
    var parent: Node?
    var children = [Node]()
    
    var name: String!
    var attr: [String: String]!
    
    var id: String!
    
    var fillRule: String?
    
    var transform: CGAffineTransform?
    
    init() {
        
    }
}

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

