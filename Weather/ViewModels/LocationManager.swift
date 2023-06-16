//
//  LocationManager.swift
//  Weather
//
//  Created by Pedro Velazquez Fernandez on 6/15/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published var location: CLLocationCoordinate2D?

        let manager = CLLocationManager()
    
        override init() {
            super.init()
            manager.delegate = self
        }
        
        func requestLocation() {
            manager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            location = locations.first?.coordinate
        }
}
