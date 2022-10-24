//
//  JCPointer.swift
//  JCompass
//
//  Created by Eran Guttentag on 16/09/2018.
//  Copyright © 2018 Gutte. All rights reserved.
//

import UIKit
import os

class JCPointer: UIView {
    private var pointerLayer: CAShapeLayer?
    private var pointerColor: UIColor = UIColor.red
    var color: UIColor {
        set {
            self.pointerColor = newValue
            self.pointerLayer?.strokeColor = newValue.cgColor
        }
        
        get {
            return self.pointerColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.clear
    }
    
    func drawLine(_ angel: Double) {
        let centerX = Double(self.bounds.width) / 2.0
        let centerY = Double(self.bounds.height) / 2.0
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: centerX, y: centerY))

        switch angel {
        case 0..<(Double.pi * 0.25):
            print("1.1")
            let x = tan(angel) * centerX
            path.addLine(to: CGPoint(x: centerX + x, y: 0))
        case (Double.pi * 0.25)..<(Double.pi * 0.5):
            print("1.2")
            let y = -tan((Double.pi * 0.5) - angel) * centerY
            path.addLine(to: CGPoint(x: Double(self.bounds.width), y: centerY + y))
        case (Double.pi * 0.5)..<(Double.pi * 0.75):
            print("2.1")
            let y = tan(angel - (Double.pi * 0.5))  * centerY
            path.addLine(to: CGPoint(x: Double(self.bounds.width), y: centerY + y))
        case (Double.pi * 0.75)..<Double.pi:
            print("2.2")
            let x = tan(Double.pi - angel) * centerX
            path.addLine(to: CGPoint(x: centerX + x, y: Double(self.bounds.height)))
        case Double.pi..<(Double.pi * 1.25):
            print("3.1")
            let x = -tan(angel - Double.pi) * Double(self.bounds.midX)
            path.addLine(to: CGPoint(x: centerX + x, y: Double(self.bounds.height)))
        case (Double.pi * 1.25)..<(Double.pi * 1.5):
            print("3.2")
            let y = tan((Double.pi * 1.5) - angel) * Double(self.bounds.midY)
            path.addLine(to: CGPoint(x: 0, y: Double(self.bounds.midY) + y))
        case (Double.pi * 1.5)...(Double.pi * 1.75):
            print("4.1")
            let y = -tan(angel - (Double.pi * 1.5)) * Double(self.bounds.midY)
            path.addLine(to: CGPoint(x: 0, y: Double(self.bounds.midY) + y))
        case (Double.pi * 1.75)...(Double.pi * 2.0):
            print("4.2")
            let x = -tan((Double.pi * 2.0) - angel) * Double(self.bounds.midX)
            path.addLine(to: CGPoint(x: Double(self.bounds.midX) + x, y: 0))
        default:
            print("5")
            fatalError("55555")
        }
        
        self.pointerLayer?.removeFromSuperlayer()
        let newLayer = CAShapeLayer.init()
        newLayer.frame = self.bounds
        newLayer.path = path.cgPath
        newLayer.strokeColor = self.pointerColor.cgColor
        newLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(newLayer)
        
        self.pointerLayer = newLayer
    }
}
