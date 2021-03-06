//
//  ViewController.swift
//  JCompass
//
//  Created by Eran Guttentag on 16/09/2018.
//  Copyright © 2018 Gutte. All rights reserved.
//

import UIKit
import os

class ViewController: UIViewController {
    private var locationManager: JCLocationManager!
    private var northLineView: JCPointer!
    private var jLine: JCPointer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = UIScreen.main.bounds.width - 5
        let midY = UIScreen.main.bounds.midY
        let lineFrame = CGRect(x: 0, y: midY - (width / 2.0), width: width, height: width)
        
        self.northLineView = JCPointer(frame: lineFrame)
        self.northLineView.color = UIColor.red
        self.northLineView.layer.cornerRadius = width / 2.0
        self.northLineView.clipsToBounds = true
        self.view.addSubview(northLineView)
        
        self.jLine = JCPointer(frame: lineFrame)
        self.jLine.color = UIColor.black
        self.jLine.layer.cornerRadius = width / 2.0
        self.jLine.clipsToBounds = true
        self.view.addSubview(jLine)
        
        self.locationManager = JCLocationManager.init(self)
    }
}

extension ViewController: JCLocationManagerDelegate {
    func locationManager(_ fromNorth: Double, direction: Double) {
        os_log("NORTH: %f\tJ: %f", fromNorth, direction)
        DispatchQueue.main.async {
            // TODO normelaize north
            let normalizedNorth = (Double.pi * 2.0) - fromNorth
            self.northLineView.drawLine(normalizedNorth)
            
            var normelizedDirection = direction - fromNorth
            if normelizedDirection >= Double.pi * 2.0 {
                normelizedDirection = normelizedDirection - Double.pi * 2.0
            } else if normelizedDirection < 0 {
                normelizedDirection = Double.pi * 2.0 + normelizedDirection
            }
            self.jLine.drawLine(normelizedDirection)
        }
    }
}
