//
//  LocationManager.swift
//  Stiint
//
//  Created by Liam Wittig on 24.01.26.
//

import CoreLocation
import Observation
import SwiftUI

public actor LocationProvider {

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

    func getCurrentLocation() async throws -> CLLocation {
        guard locationAvailable else {
            throw LocationError.notAuthorized
        }

        for try await update in CLLocationUpdate.liveUpdates() {
            if let location = update.location {
                print(location)
                return location
            }
        }

        throw LocationError.noLocation
    }
}

public extension LocationProvider {
    static let shared = LocationProvider()
}


enum LocationError: Error {
    case notAuthorized
    case noLocation
}


