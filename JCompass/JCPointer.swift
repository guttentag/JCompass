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
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        self.drawLine()
//
//    }
    
    func drawLine(_ angel: Double) {
//    func drawLine(_ point: CGPoint) {
//        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: self.bounds.height / 2.0, startAngle: 0, endAngle: CGFloat(direction), clockwise: true)
        
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
        self.pointerLayer = CAShapeLayer.init()
        self.pointerLayer?.frame = self.bounds
        pointerLayer?.path = path.cgPath
        pointerLayer?.strokeColor = UIColor.red.cgColor
        pointerLayer?.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(self.pointerLayer!)
    }
}
