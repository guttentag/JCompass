//
//  AppViewModel.swift
//  JCompass
//
//  Created by Eran Gutentag on 26/10/2022.
//  Copyright © 2022 Gutte. All rights reserved.
//

import CoreLocation.CLLocation
import Combine

class AppViewModel {
    private static let templeMount = CLLocationCoordinate2D(latitude: CLLocationDegrees(31.778000), longitude: CLLocationDegrees(35.235359))
    private static let locationManager = JCLocationManager()
    
    let userDeniedAuthorized: AnyPublisher<Bool,Never>
    let jerusalemPointer: LocationPointer
    
    init() {
        jerusalemPointer = LocationPointer(location: Self.templeMount, locationManager: Self.locationManager)
        userDeniedAuthorized = Self.locationManager.$authorizationStatus
            .map { $0 == .userDenied }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
