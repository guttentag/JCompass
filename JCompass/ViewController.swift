//
//  ViewController.swift
//  JCompass
//
//  Created by Eran Guttentag on 16/09/2018.
//  Copyright © 2018 Gutte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var locationManager: JCLocationManager!
    private var northLineView: JCPointer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = UIScreen.main.bounds.width
        let midY = UIScreen.main.bounds.midY
        let lineFrame = CGRect(x: 0, y: midY - (width / 2.0), width: width, height: width)
        self.northLineView = JCPointer(frame: lineFrame)
        self.view.addSubview(northLineView)
        
        self.locationManager = JCLocationManager.init(self)
    }
}

extension ViewController: JCLocationManagerDelegate {
    func locationManager(_ north: Double, direction: Double) {
//        print("NORTH: \(north)\tJ: \(direction)")
        DispatchQueue.main.async {
            self.northLineView.drawLine(north)
        }
    }
}
