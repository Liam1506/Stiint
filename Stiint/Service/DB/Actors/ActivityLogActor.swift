//
//  ActivityLogActor.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation
import SwiftData
import CoreLocation
import os

@ModelActor
public actor ActivityLogActor {
    public func startActivity(activityId: UUID, previousAcvitiyLogId: UUID? = nil) async -> UUID? {
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
            predicate: #Predicate { $0.id == activityId }
        )
        let activity = try? modelContext.fetch(fetchDescriptor).first
        
        var startLocation: CLLocation? = nil
        
        if(activity?.storeLocation == true){
            startLocation = try? await LocationProvider.shared.getCurrentLocation()
        }

        let activityLog = ActivityLog(activity: activity, previousActivityLogId: previousAcvitiyLogId, startLocation: startLocation)

        modelContext.insert(activityLog)
        try? modelContext.save()
        return activityLog.id
    }
    
    
    public func insertActivityLog(activityId: UUID, startTime: Date, endTime: Date){
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
               predicate: #Predicate { $0.id == activityId }
           )
           let activity = try? modelContext.fetch(fetchDescriptor).first
        
        
        let activityLog = ActivityLog(startTime: startTime, endTime: endTime, activity: activity)
        
        modelContext.insert(activityLog)
        try? modelContext.save()
        
        
    }

    
    // This function should never do anything, but gurantees data integrity
    public func killDeadActvities(knwonRunningid: UUID?) throws {
        
        var idToTest = knwonRunningid
        if knwonRunningid == nil {
            idToTest = UUID()
        }
        let logsToDelete = #Predicate<ActivityLog> { log in
            log.endTime == nil && log.id != idToTest
            
           }
        
        let descriptor = FetchDescriptor<ActivityLog>(predicate: logsToDelete)
        let logs = try modelContext.fetch(descriptor)
        for log in logs {
            print("Deleting: \(String(describing: log.activity?.name))")
            print("WARNING: This should not happen")
            delete(activityLog: log)
            
        }
        
        
    }
    
    
    public func clearTimeFrame(startDate: Date, endDate: Date, logId: UUID, currentActivityStartDate: Date? = nil) throws {
        let defaultDate = Date.distantPast
        let defaultDateFuture = Date.distantFuture
        
        if let currentActivityStartDate{
            guard endDate <= currentActivityStartDate else { throw(ActivityLogActorErrors.cannotOverwriteRunningActivity) }
        }
        
        // 0. Split logs that span the entire range
        let logsToSplit = #Predicate<ActivityLog> { log in
            (log.startTime ?? defaultDate) < startDate &&
            (log.endTime ?? defaultDate) > endDate
        }
        let splitDescriptor = FetchDescriptor<ActivityLog>(predicate: logsToSplit)
        let dataToSplit = try modelContext.fetch(splitDescriptor)
        
        for log in dataToSplit {
            guard log.id != logId else { continue }
            guard log.endTime != nil else { throw(ActivityLogActorErrors.cannotOverwriteRunningActivity) }

            insertActivityLog(activityId: log.activity!.id!, startTime: endDate, endTime: log.endTime ?? Date.now)
            log.endTime = startDate
        }
        
        let logsToDelete = #Predicate<ActivityLog> { log in
            (log.startTime ?? defaultDate) >= startDate &&
            (log.endTime ?? defaultDateFuture) <= endDate
        }
        let deleteDescriptor = FetchDescriptor<ActivityLog>(predicate: logsToDelete)
        let dataToDelete = try modelContext.fetch(deleteDescriptor)
        
        for log in dataToDelete {
            guard log.id != logId else { continue }
            guard log.endTime != nil else { throw(ActivityLogActorErrors.cannotOverwriteRunningActivity) }
            delete(activityLog: log)
        }
        
        // 2. Truncate logs that start before range and end within range
        let logsStartingBefore = #Predicate<ActivityLog> { log in
            (log.startTime ?? defaultDate) < startDate &&
            (log.endTime ?? defaultDate) > startDate &&
            (log.endTime ?? defaultDate) <= endDate
        }
        let beforeDescriptor = FetchDescriptor<ActivityLog>(predicate: logsStartingBefore)
        let dataStartingBefore = try modelContext.fetch(beforeDescriptor)
        
        for log in dataStartingBefore {
            guard log.id != logId else { continue }
            print("3")
            guard log.endTime != nil else { throw(ActivityLogActorErrors.cannotOverwriteRunningActivity) }
            log.endTime = startDate
        }
        
        // 3. Truncate logs that start within range and end after range
        let logsEndingAfter = #Predicate<ActivityLog> { log in
            (log.startTime ?? defaultDate) >= startDate &&
            (log.startTime ?? defaultDate) < endDate &&
            (log.endTime ?? defaultDate) > endDate
        }
        let afterDescriptor = FetchDescriptor<ActivityLog>(predicate: logsEndingAfter)
        let dataEndingAfter = try modelContext.fetch(afterDescriptor)
        
        for log in dataEndingAfter {
            guard log.id != logId else { continue }
            guard log.endTime != nil else { throw(ActivityLogActorErrors.cannotOverwriteRunningActivity) }
            
            log.startTime = endDate
        }
        
        try modelContext.save()
    }

    public func getActivityLogsForTimeFrame(filterData: FilterData) -> [ActivityLog] {
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

    public func getAllActivityLogs() -> [ActivityLog] {
        let fetchDescriptor = FetchDescriptor<ActivityLog>()
        do {
            let data = try modelContext.fetch(fetchDescriptor)
            return data
        } catch {
            print("Database fetch failed: \(error)")
            return []
        }
    }

    public func resumeActivity(activityLogId: UUID) -> UUID? {
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
              let startTime = activityLog.startTime
        else {
            return nil
        }

        return ActivityDTO(id: activityId, name: activityName, startTime: startTime, icon: activity.sfSymbolName ?? "questionmark.circle.fill", color: activity.color, weekdays: activity.weekdays ?? [], endTime: activityLog.endTime)
    }

    private func isActivtyLongerThen(date: Date, min: Double) -> Bool {
        let seconds = min * 60
        let now = Date.now
        return now.timeIntervalSince(date) <= seconds
    }

    public func stopActivity(activityLogId: UUID) async {
        let activityLog = getActivityLogById(from: activityLogId)
        activityLog!.endTime = Date.now
        
        if(activityLog?.activity?.storeLocation == true){
            let endLocation = try? await LocationProvider.shared.getCurrentLocation()
            activityLog?.endLatitude = endLocation?.coordinate.latitude
            activityLog?.endLongitude = endLocation?.coordinate.longitude
        }
          

        try? modelContext.save()
    }

    public func getActivityLogById(from activityLogId: UUID) -> ActivityLog? {
        let fetchDescriptor = FetchDescriptor<ActivityLog>(
            predicate: #Predicate { $0.id == activityLogId }
        )
        let activityLog = try? modelContext.fetch(fetchDescriptor)

        return activityLog?.first
    }

    public func editActivityLogById(activityId: UUID, newActivity: ActivityItem) {
        let fetchDescriptor = FetchDescriptor<ActivityItem>(
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



