//
//  LocationHandler.swift
//  Stiint
//
//  Created by Liam Wittig on 24.01.26.
//

import CoreLocation

class LocationHandler {
    func formatDistance(
         startLat: Double, startLon: Double,
         endLat: Double, endLon: Double
    ) -> String {
        let startLocation = CLLocation(latitude: startLat, longitude: startLon)
        let endLocation = CLLocation(latitude: endLat, longitude: endLon)
        
        let distanceInMeters = startLocation.distance(from: endLocation)
        
        // Automatically choose unit
        if distanceInMeters < 1000 {
            return String(format: "%.0f meters", distanceInMeters)
        } else {
            let distanceInKm = distanceInMeters / 1000
            return String(format: "%.2f km", distanceInKm)
        }
    }
}
