//
//  ViewController.swift
//  Demo
//
//  Created by Zeacone on 2018/1/21.
//  Copyright © 2018年 zeacone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let filePath = Bundle.main.path(forResource: "Mahuri", ofType: "svg")
        
        let svgView = SVGView().parse(filePath!)
        svgView.center = CGPoint(x: 200, y: 300)
        svgView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
        
        self.view.addSubview(svgView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

