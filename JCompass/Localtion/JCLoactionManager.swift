//
//  LoactionManager.swift
//  JCompass
//
//  Created by Eran Guttentag on 16/09/2018.
//  Copyright © 2018 Gutte. All rights reserved.
//

import CoreLocation
import Combine
import os.log

class JCLocationManager: NSObject {
    enum LocationAuthrizationStatus {
        case notRequested
        case userDenied
        case approved
    }
    private let clManager = CLLocationManager()
    private let privateQueue = DispatchQueue(label: "LocationManagerPrivatQeueue")
    @Published private(set) var authorizationStatus: LocationAuthrizationStatus
    @Published private(set) var currentHeading: CLHeading?
    @Published private(set) var currentLocation: CLLocation?
    
    override init() {
        self.authorizationStatus = .notRequested
        super.init()
        // End init
        
        // TODO remove:
        clManager.delegate = self
        requestAuthorization()
        
        // TODO location updates logic:
        // based on subscribers
        // based on poition accuracy
    }
}

private extension JCLocationManager {
    func requestAuthorization() {
        os_log(.debug, log: .CoreLocation ,"request authorization")
        clManager.requestWhenInUseAuthorization()
    }
}

extension JCLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        os_log(.info, log: .CoreLocation, "location authorization status updated \(String(describing: status), privacy: .public)")
        
        self.privateQueue.sync { [weak self] in
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self?.clManager.startUpdatingLocation()
                self?.clManager.startUpdatingHeading()
                self?.authorizationStatus = .approved
            case .denied, .restricted, .notDetermined:
                self?.clManager.stopUpdatingHeading()
                self?.clManager.stopUpdatingLocation()
                self?.authorizationStatus = status == .notDetermined ? .notRequested : .userDenied
            @unknown default:
                // TODO uknown future handling
                break;
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        os_log(.info, log: .CoreLocation, "location updated. accuracy \(String(describing: locations.first?.horizontalAccuracy))")
        self.privateQueue.sync { [weak self] in
            self?.currentLocation = locations.first
        }
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        os_log(.debug, log: .CoreLocation, "heading display")
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        os_log(.debug, log: .CoreLocation, "heading updated. accuracy: \(newHeading.headingAccuracy)")
        self.privateQueue.sync { [weak self] in
            self?.currentHeading = newHeading
        }
    }
}

private extension OSLog {
    static var CoreLocation = JCLog(category: "Core Location")
}
