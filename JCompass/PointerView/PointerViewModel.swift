//
//  PointerViewModel.swift
//  JCompass
//
//  Created by Eran Gutentag on 24/10/2022.
//  Copyright © 2022 Gutte. All rights reserved.
//

import Combine
import os.log

class PointerViewModel: ObservableObject {
    private let locationManager = JCLocationManager()
    @Published var angle: Double? = .none
    
    init() {
        locationManager.setDelegate(self)
    }
}

extension PointerViewModel: JCLocationManagerDelegate {
    func locationManager(_ fromNorth: Double, direction: Double) {
        var normelizedDirection = direction - fromNorth
        if normelizedDirection >= Double.pi * 2 {
            normelizedDirection = normelizedDirection - Double.pi * 2
        } else if normelizedDirection < 0 {
            normelizedDirection = Double.pi * 2 + normelizedDirection
        }
        
        angle = normelizedDirection
    }
}
