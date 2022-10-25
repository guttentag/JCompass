//
//  LoactionManager.swift
//  JCompass
//
//  Created by Eran Guttentag on 16/09/2018.
//  Copyright © 2018 Gutte. All rights reserved.
//

import CoreLocation
import os.log

protocol JCLocationManagerDelegate: class {
    func locationManager(_ fromNorth: Double, direction: Double)
}

class JCLocationManager: NSObject {
    private static let destination = CLLocation(latitude: CLLocationDegrees(31.778000), longitude: CLLocationDegrees(35.235359))
    private let clManager: CLLocationManager
    private let privateQueue: DispatchQueue
    private(set) var authorizationStatus: CLAuthorizationStatus
    private var currentHeading: CLHeading?
    private var currentLocation: CLLocation?
    private unowned var delegate: JCLocationManagerDelegate?
    
    override init() {
        self.clManager = CLLocationManager()
        self.privateQueue = DispatchQueue(label: "LocationManagerPrivatQeueue")
        self.authorizationStatus = .notDetermined
        super.init()
        
        self.clManager.delegate = self
        self.requestAuthorization()
    }
    
    func setDelegate(_ delegate: JCLocationManagerDelegate) {
        self.delegate = delegate
    }
    
    // TODO start/stop methods
}

private extension JCLocationManager {
    func requestAuthorization() {
        os_log(.debug, "LM request")
        clManager.requestWhenInUseAuthorization()
    }
    
    func calculateHeading(_ location: CLLocation, heading: CLHeading) -> CLLocationDegrees {
        let normelizedDegrees = self.getRadiansBearingBetweenTwoPoints1(point1: location, point2: JCLocationManager.destination)
        
        return normelizedDegrees
    }
    
    func getRadiansBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansBearing
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / Double(180) }
    func radiansToDegrees(radians: Double) -> Double { return radians * Double(180) / .pi }
}

extension JCLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.privateQueue.sync {
            self.authorizationStatus = status
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self.clManager.startUpdatingLocation()
                self.clManager.startUpdatingHeading()
            case .denied, .restricted, .notDetermined:
                self.clManager.stopUpdatingHeading()
                self.clManager.stopUpdatingLocation()
            }
            // TODO update delegate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        os_log("LM location updated. accuracy \(String(describing: manager.location?.horizontalAccuracy))")
        self.privateQueue.sync {
            self.currentLocation = locations.first
            guard let location = self.currentLocation, let heading = self.currentHeading else {
                os_log(.error, "LM location or heading is missing")
                return
            }
            
            let degrees = self.calculateHeading(location, heading: heading)
            let direction = self.degreesToRadians(degrees: heading.trueHeading)
            self.delegate?.locationManager(direction, direction: degrees)
        }
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        os_log("LM heading display")
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        os_log("LM heading updated. accuracy: \(newHeading.headingAccuracy)")
        self.privateQueue.sync {
            self.currentHeading = newHeading
            guard let location = self.currentLocation, let heading = self.currentHeading else {
                os_log(.error, "LM location or heading is missing")
                return
            }
            
            let direction = self.calculateHeading(location, heading: heading)
            let north = self.degreesToRadians(degrees: /*Double(360) - */heading.trueHeading)
            self.delegate?.locationManager(north, direction: direction)
        }
    }
}
