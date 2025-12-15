//
//  ActivityLog.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation

import Foundation
import SwiftData
import SwiftUI

@Model
public final class ActivityLog{
    
    
    public var id: UUID?
    public var startTime: Date?
    public var endTime: Date?
    public var activity: Activity?
    public var previousActivityLogId: UUID?
    

    public init(
        startTime: Date? = nil,
        activity: Activity? = nil,
        previousActivityLogId: UUID? = nil,
        
        
    ) {
        self.id = id ?? UUID()
        self.startTime = startTime ?? Date.now
        self.endTime = nil
        self.activity = activity
        self.previousActivityLogId = previousActivityLogId
    }

}
