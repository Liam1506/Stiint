//
//  LocationManager.swift
//  Stiint
//
//  Created by Liam Wittig on 24.01.26.
//

import CoreLocation
import Observation
import SwiftUI

@Observable
public final class LocationProvider {

    private let locationManager = CLLocationManager()

    public var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }

    public var locationAvailable: Bool {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            true
        default:
            false
        }
    }

    func requestAuthorization() {
        switch authorizationStatus {
        case .denied, .restricted:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
       
        
    }

    func getCurrentLocation() async throws -> CLLocation {
        guard locationAvailable else {
            throw LocationError.notAuthorized
        }

        for try await update in CLLocationUpdate.liveUpdates() {
            if let location = update.location {
                return location
            }
        }

        throw LocationError.noLocation
    }
}

enum LocationError: Error {
    case notAuthorized
    case noLocation
}


