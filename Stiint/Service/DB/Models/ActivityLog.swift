//
//  ActivityLog.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation
import SwiftData
import SwiftUI
import CoreLocation

@Model
public final class ActivityLog {
    public var id: UUID?
    public var startTime: Date?
    public var endTime: Date?
    public var activity: ActivityItem?
    public var previousActivityLogId: UUID?
    
    public var startLatitude: Double?
    public var startLongitude: Double?
    public var endLatitude: Double?
    public var endLongitude: Double?
    
    
    public init(
        startTime: Date? = nil,
        endTime: Date? = nil,
        activity: ActivityItem? = nil,
        previousActivityLogId: UUID? = nil,
        startLocation: CLLocation? = nil,
        endLocation: CLLocation? = nil,

    ) {
        id = id ?? UUID()
        self.startTime = startTime ?? Date.now
        self.endTime = endTime
        self.activity = activity
        self.previousActivityLogId = previousActivityLogId

        
        self.startLatitude = startLocation?.coordinate.latitude
             self.startLongitude = startLocation?.coordinate.longitude
             self.endLatitude = endLocation?.coordinate.latitude
             self.endLongitude = endLocation?.coordinate.longitude
    }
}
