//
//  ActivityActor.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation
import SwiftData
import SwiftUI

@ModelActor
public actor ActivityActor {
    public func addActivity(name: String, color: Color = .blue, icon: String? = nil, weekdays: Set<Weekday> = []) {
        if getActivityByName(from: name) != nil {
            return
        }
        let activity = ActivityItem(name: name, color: color, sfSymbolName: icon, weekdays: weekdays)
        modelContext.insert(activity)
        try? modelContext.save()
    }

    public func editActivityById(activityId: UUID, newName: String? = nil, newColor: Color? = nil, newIcon: String? = nil, weekdays: Set<Weekday> = []) {
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
            predicate: #Predicate { $0.id == activityId }
        )
        let activity = try? modelContext.fetch(fetchDescriptor).first

        activity?.name = newName
        activity?.color = newColor ?? activity!.color
        activity?.sfSymbolName = newIcon
        activity?.weekdays = weekdays

        try? modelContext.save()
    }

    public func getAllAvaibleActivitys() -> [ActivityItem] {
        let fetchDescriptor = FetchDescriptor<ActivityItem>()
        let activitys = try? modelContext.fetch(fetchDescriptor)

        return activitys ?? []
    }

    public func getActivityByName(from name: String) -> ActivityItem? {
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
            predicate: #Predicate { $0.name == name }
        )
        let activity = try? modelContext.fetch(fetchDescriptor)

        return activity?.first
    }

    public func getActivityById(from activityId: UUID) -> ActivityItem? {
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
            predicate: #Predicate { $0.id == activityId }
        )
        let activity = try? modelContext.fetch(fetchDescriptor)

        return activity?.first
    }

    public func addWeekday(from activityId: UUID, weekday: Weekday) {
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
            predicate: #Predicate { $0.id == activityId }
        )
        let activity = try? modelContext.fetch(fetchDescriptor).first
        activity?.weekdays?.insert(weekday)

        try? modelContext.save()
    }

    public func removeWeekday(from activityId: UUID, weekday: Weekday) {
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
            predicate: #Predicate { $0.id == activityId }
        )
        let activity = try? modelContext.fetch(fetchDescriptor).first
        activity?.weekdays?.remove(weekday)

        try? modelContext.save()
    }

    public func delete(from activityId: UUID) {
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
            predicate: #Predicate { $0.id == activityId }
        )
        let activity = try? modelContext.fetch(fetchDescriptor).first
        activity!.deleted = true

        try? modelContext.save()
    }
}
