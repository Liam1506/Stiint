//
//  ActivityLogActor.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//


import Foundation
import SwiftData


@ModelActor
public actor ActivityLogActor {
    public func startActivity(activityId: UUID)-> UUID? {
        
        let fetchDescriptor = FetchDescriptor<Activity>(
                    predicate: #Predicate { $0.id == activityId }
                )
             let activity = try? modelContext.fetch(fetchDescriptor).first
             
        let activityLog = ActivityLog(activity: activity)
        modelContext.insert(activityLog)
        try? modelContext.save()
        return activityLog.id
        
    }
    
    public func getStartTimeOfActivityLog(activityLogId: UUID) -> ActivityDTO? {
        let fetchDescriptor = FetchDescriptor<ActivityLog>(
            predicate: #Predicate { $0.id == activityLogId }
        )
        let activityLog = try? modelContext.fetch(fetchDescriptor).first
        
        guard let activityLog = activityLog,
              let activity = activityLog.activity,
              let activityId = activity.id,
              let activityName = activity.name,
              let startTime = activityLog.startTime else {
            return nil
        }
        
        return ActivityDTO(id: activityId, name: activityName, startTime: startTime, icon: activity.sfSymbolName ?? "questionmark.circle.fill", color: activity.color)
    }
    
    
    public func stopActivity(activityLogId: UUID) {
        let activityLog = getActivityLogById(from: activityLogId)
        activityLog!.endTime = Date.now
        try? modelContext.save()
    }
    
    
    public func getActivityLogById(from activityLogId: UUID) -> ActivityLog?{
        let fetchDescriptor = FetchDescriptor<ActivityLog>(
               predicate: #Predicate { $0.id == activityLogId }
           )
        let activityLog = try? modelContext.fetch(fetchDescriptor)
        
        return activityLog?.first
    }

    
    public func editActivityLogById(activityId: UUID, newActivity: Activity) {
        let fetchDescriptor = FetchDescriptor<Activity>(
               predicate: #Predicate { $0.id == activityId }
           )
        let activity = try? modelContext.fetch(fetchDescriptor).first
        
        activity?.name = newActivity.name
        
        try? modelContext.save()
    }

    public func delete(activityLog: ActivityLog) {
        modelContext.delete(activityLog)
        try? modelContext.save()
    }
}
