//
//  AnalytcisDataProvider.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import Foundation

class AnalyticsDataProvider{
    
    init(){
        
    }
    public func loadDataForTimeFrame(filterData: FilterData) async -> TimeFrameData {
        let logs = await PersistenceManager.shared.activityLogActor.getActivitiesForTimeFrame(filterData: filterData)
        var dataPoints: [DataPoint] = []
        
        
        for log in logs {
            print(log)
            if let point =  dataPoints.first(where: { DataPoint in
                DataPoint.activity == log.activity
            }){
                point.addTimeSpend(log.endTime?.timeIntervalSince(log.startTime!) ?? Date.now.timeIntervalSince(log.startTime!))
            }else{
                dataPoints.append(DataPoint(activity: log.activity!, timeSpend: log.endTime?.timeIntervalSince(log.startTime!) ?? 0, startDate: filterData.startDate, endDate: filterData.endDate))
            }
            
        }
        
        
        
        return TimeFrameData(dataPoints: dataPoints, start: filterData.startDate, end: filterData.endDate)
        
    }
    
}




class DataPoint: Identifiable {
    let id: UUID;
    let activity: Activity
    var timeSpend: Double
    var startDate: Date
    var endDate: Date
    

    var timeAvg: Double {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 1
        let numberOfDays = max(days + 1, 1)
        return timeSpend / Double(numberOfDays)
    }
    
    
    init(activity: Activity, timeSpend: Double, startDate: Date, endDate: Date) {
        self.id = UUID()
        self.activity = activity
        self.timeSpend = timeSpend
        self.startDate = startDate
        self.endDate = endDate
 

    }
    
    public func addTimeSpend(_ time: Double) {
        timeSpend = timeSpend + time
    }
}

class TimeFrameData{
    let dataPoints: [DataPoint]
    let start: Date
    let end: Date
    let timeOverall: Double
    let timeSpendOnActivities: Double
    
    var timeSpendOnActivitiesAvg: Double {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: start, to: end).day ?? 1
        let numberOfDays = max(days + 1, 1)
        return timeSpendOnActivities / Double(numberOfDays)
    }
    init(dataPoints: [DataPoint], start: Date, end: Date) {
        self.dataPoints = dataPoints
        self.start = start
        self.end = end
        timeOverall = end.timeIntervalSince(start)
        var ts: Double = 0
        for point in dataPoints {
            ts = ts + point.timeSpend
        }
        timeSpendOnActivities = ts
    }
}
