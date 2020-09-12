//
//  LocationManager.swift
//
//  Created by Ravi Vora on 12/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import CoreLocation

protocol UserLocationManagerDelegate: class {
    func locationdidUpdateToLocation(location: CLLocation)
}

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: UserLocationManagerDelegate?
    static let sharedManager = UserLocationManager()
    private var locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.delegate?.locationdidUpdateToLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}
