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
    public func loadDataForTimeFrame(start: Date, end: Date) async -> TimeFrameData {
        let logs = await PersistenceManager.shared.activityLogActor.getActivitisForTimeFrame(start: start, end: end)
        var dataPoints: [DataPoint] = []
        
        for log in logs {
            print(log)
            if let point =  dataPoints.first(where: { DataPoint in
                DataPoint.activity == log.activity
            }){
                point.addTimeSpend(log.endTime?.timeIntervalSince(log.startTime!) ?? Date.now.timeIntervalSince(log.startTime!))
            }else{
                dataPoints.append(DataPoint(Activity: log.activity!, timeSpend: log.endTime?.timeIntervalSince(log.startTime!) ?? 0))
            }
            
        }
        
        
        return TimeFrameData(dataPoints: dataPoints, start: start, end: end)
        
    }
    
}




class DataPoint{
    let activity: Activity;
    var timeSpend: Double;
    init(Activity: Activity, timeSpend: Double) {
        self.activity = Activity
        self.timeSpend = timeSpend
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
