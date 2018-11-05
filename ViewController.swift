//
//  ViewController.swift
//  TrangleMetal
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        
        let trangle = TrangleMetalView(frame: CGRect.init(x: 50, y: 100, width: 300, height: 300))
        
        self.view.addSubview(trangle)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

