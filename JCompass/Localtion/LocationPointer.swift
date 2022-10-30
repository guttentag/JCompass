//
//  LocationPointer.swift
//  JCompass
//
//  Created by Eran Gutentag on 26/10/2022.
//  Copyright © 2022 Gutte. All rights reserved.
//

import Combine
import CoreLocation.CLLocation

class LocationPointer {
    let pointer: AnyPublisher<Double?,Never>
    
    init(location: CLLocationCoordinate2D, locationManager: JCLocationManager) {
        let locationAzimuth = locationManager.$currentLocation
            .map { currentLocation -> Double? in
                guard let currentLocation = currentLocation?.coordinate else { return .none }
                return LocationUtils.getRadiansBearingBetweenTwoPoints(point1: currentLocation, point2: location)
            }
        
        pointer = Publishers.CombineLatest(locationAzimuth, locationManager.$currentHeading)
            .map { requiredHeading, actualHeading -> Double? in
                guard
                    let requiredHeading = requiredHeading,
                    let actualHeadingDegrees = actualHeading?.trueHeading
                else { return .none }
                
                let actualHeading = LocationUtils.degreesToRadians(degrees: actualHeadingDegrees)
                return requiredHeading - actualHeading
            }
            .eraseToAnyPublisher()
    }
}
