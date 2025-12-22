//
//  AnalytcisDataProvider.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import Foundation
import SwiftUI

class AnalyticsDataProvider{

    public func loadDataForTimeFrame(filterData: FilterData) async -> TimeFrameData {
        let logs = await PersistenceManager.shared.activityLogActor.getActivitiesForTimeFrame(filterData: filterData)
        
        let dataFrame = TimeFrameData(filterData: filterData, logs: logs)
    
        
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

class DataSeriesPoint: Identifiable {
    let id: UUID;
    let activity: ActivityItem
    let date: Date
    var timeSpend: Double
    let color: Color

    init(activity: ActivityItem, timeSpend: Double, date: Date) {
        self.id = UUID()
        self.activity = activity
        self.timeSpend = timeSpend
        self.date = date
        self.color = activity.color

    }
}

class TimeFrameData{
    var dataPoints: [DataPoint]
    var dataSeries: [DataSeriesPoint]
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
    
    init(filterData: FilterData, logs: [ActivityLog]) {
        self.filterData = filterData
        self.dataSeries = []
        self.dataPoints = []
        
        for log in logs {
            self.insertLog(log: log)
            self.insertSeries(log: log)
        }
    
        
    }
    
    private func insertSeries(log: ActivityLog){
       
        guard let activity = log.activity else { return }
        
            let calendar = Calendar.current
        
        
        let startTime = log.startTime!
        var endTime = log.endTime ?? Date.now
        
        
        
        guard endTime > startTime else { return }
        
        
        
        var dateToSave = calendar.startOfDay(for: startTime)
        if dateToSave < filterData.startDate {
            dateToSave = calendar.startOfDay(for: filterData.startDate)
        }
        
        if endTime > filterData.endDate {
            endTime = filterData.endDate
        }
        
        
        if let point = dataSeries.first(where: { point in
            point.date == dateToSave && point.activity == log.activity
        }) {
            // point found, do something with it
            point.timeSpend += endTime.timeIntervalSince(startTime)
        }else{
            
            self.dataSeries.append(DataSeriesPoint(activity: activity, timeSpend: endTime.timeIntervalSince(startTime), date: dateToSave))
        }
    }
    
    private func insertLog(log: ActivityLog){
        
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
