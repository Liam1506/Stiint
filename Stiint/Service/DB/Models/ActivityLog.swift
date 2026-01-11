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
public final class ActivityLog {
    public var id: UUID?
    public var startTime: Date?
    public var endTime: Date?
    public var activity: ActivityItem?
    public var previousActivityLogId: UUID?

    public init(
        startTime: Date? = nil,
        activity: ActivityItem? = nil,
        previousActivityLogId: UUID? = nil

    ) {
        id = id ?? UUID()
        self.startTime = startTime ?? Date.now
        endTime = nil
        self.activity = activity
        self.previousActivityLogId = previousActivityLogId
    }
}
