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
    public func startActivity(activityId: UUID, previousAcvitiyLogId: UUID? = nil)-> UUID? {
        
        let fetchDescriptor = FetchDescriptor<Activity>(
                    predicate: #Predicate { $0.id == activityId }
                )
             let activity = try? modelContext.fetch(fetchDescriptor).first
        

        let activityLog = ActivityLog(activity: activity, previousActivityLogId: previousAcvitiyLogId)
        
        
        print("activityLog \(activityLog)")
        modelContext.insert(activityLog)
        try? modelContext.save()
        return activityLog.id
        
    }
    
    
    
    public func getActivitiesForTimeFrame(filterData: FilterData) -> [ActivityLog] {
        let defaultDate = Date.distantPast
        let startDate = filterData.startDate
        let endDate = filterData.endDate
        let selectedIds: [UUID] = filterData.selectedActivityIds
        
        // Glaub hier muss endzeit genommen werden
        let afterStartDate = #Predicate<ActivityLog> { log in
            (log.endTime ?? defaultDate) > startDate
        }
        
        
        // Hier passt es
        let beforeEndDate = #Predicate<ActivityLog> { log in
            (log.startTime ?? defaultDate) < endDate
        }
        
        // Combine predicates
        let fetchDescriptor = FetchDescriptor<ActivityLog>(
            predicate: #Predicate { log in
                afterStartDate.evaluate(log) &&
                beforeEndDate.evaluate(log)
            }
        )
        
        // Fetch with proper error handling
        do {
            let data = try modelContext.fetch(fetchDescriptor)
            return data.filter { log in
                selectedIds.contains(log.activity!.id!)
            }
        } catch {
            print("Database fetch failed: \(error)")
            return []
        }
    }
    
    public func resumeActivity(activityLogId: UUID)-> UUID? {
        print("Try to resume activity")
        let fetchDescriptor = FetchDescriptor<ActivityLog>(
            predicate: #Predicate { $0.id == activityLogId }
        )
        let activityLog = try? modelContext.fetch(fetchDescriptor).first
        
        if activityLog == nil { return nil }
        
        activityLog!.endTime = nil
        try? modelContext.save()
        return activityLog!.id
        
    }
    
    public func getPreviousActivtyLogID(activityLogId: UUID) -> UUID? {
        let fetchDescriptor = FetchDescriptor<ActivityLog>(
            predicate: #Predicate { $0.id == activityLogId }
        )
        let activityLog = try? modelContext.fetch(fetchDescriptor).first
        
        return activityLog?.previousActivityLogId
    }
    
    public func getActivtyLogDTO(activityLogId: UUID) -> ActivityDTO? {
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
        
        return ActivityDTO(id: activityId, name: activityName, startTime: startTime, icon: activity.sfSymbolName ?? "questionmark.circle.fill", color: activity.color, weekdays: activity.weekdays, endTime: activityLog.endTime)
    }
    
    
private func isActivtyLongerThen(date: Date, min: Double) -> Bool{
        
        let seconds = min * 60
        let now = Date.now
        return now.timeIntervalSince(date) <= seconds
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
