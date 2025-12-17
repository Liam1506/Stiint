//
//  AnalytcisDataProvider.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import Foundation

class AnalyticsDataProvider{

    public func loadDataForTimeFrame(filterData: FilterData) async -> TimeFrameData {
        let logs = await PersistenceManager.shared.activityLogActor.getActivitiesForTimeFrame(filterData: filterData)
        
        let dataFrame = TimeFrameData(filterData: filterData)
        
        for log in logs {
            dataFrame.insertLog(log: log)
        }
        
        return dataFrame
    }
    
}

class DataPoint: Identifiable {
    let id: UUID;
    let activity: ActivityItem
    var timeSpend: Double
    let filterData: FilterData
    

    var timeAvg: Double {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: filterData.startDate, to: filterData.endDate).day ?? 1
        let numberOfDays = max(days, 1)
        return timeSpend / Double(numberOfDays)
    }
    
    
    init(activity: ActivityItem, timeSpend: Double, filterData: FilterData) {
        self.id = UUID()
        self.activity = activity
        self.timeSpend = timeSpend
        self.filterData = filterData
 

    }
    
    public func addTimeSpend(_ time: Double) {
        timeSpend = timeSpend + time
    }
}

class TimeFrameData{
    var dataPoints: [DataPoint]
    let filterData: FilterData
    
    
    var timeSpendOnActivities: Double {
        var timeSpend: Double = 0
        dataPoints.forEach { (dp) in
            timeSpend = timeSpend + dp.timeSpend
        }
        return timeSpend
    }
    
    var timeOverall: Double {
        return filterData.endDate.timeIntervalSince(filterData.startDate)
    }
    
    var timeSpendOnActivitiesAvg: Double {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: filterData.startDate, to: filterData.endDate).day ?? 1
        let numberOfDays = max(days, 1)
        return timeSpendOnActivities / Double(numberOfDays)
    }
    var timeOverallAvg: Double {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: filterData.startDate, to: filterData.endDate).day ?? 1
        let numberOfDays = max(days, 1)
        return timeOverall / Double(numberOfDays)
    }
    
    init(dataPoints: [DataPoint] = [], filterData: FilterData) {
        self.dataPoints = dataPoints
        self.filterData = filterData
    }
    
    public func insertLog(log: ActivityLog){
        
        var startTime = log.startTime ?? filterData.startDate
        var endTime = log.endTime ?? filterData.endDate
        
        
        guard let activity = log.activity else { return }
        
        // Clamp to filter range
        if startTime < filterData.startDate {
            startTime = filterData.startDate
        }
        if endTime > filterData.endDate {
            endTime = filterData.endDate
        }
        
        guard endTime > startTime else { return }
        
        if let point =  dataPoints.first(where: { DataPoint in
            DataPoint.activity == activity
        }){
            point.addTimeSpend(endTime.timeIntervalSince(startTime))
            
        } else {
            self.dataPoints.append(DataPoint(activity: activity, timeSpend: endTime.timeIntervalSince(startTime), filterData: filterData))
        }
    }
}
