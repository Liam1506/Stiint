//
//  AnalytcisDataProvider.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import Foundation
import SwiftUI

class AnalyticsDataProvider {
    func loadDataForTimeFrame(filterData: FilterData) async -> TimeFrameData {
        let logs = await PersistenceManager.shared.activityLogActor.getActivityLogsForTimeFrame(filterData: filterData)

        let dataFrame = TimeFrameData(filterData: filterData, logs: logs)

        return dataFrame
    }
}

struct DataPoint: Identifiable, Equatable {
    let id: UUID
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
        id = UUID()
        self.activity = activity
        self.timeSpend = timeSpend
        self.filterData = filterData
    }
}

struct DataSeriesPoint: Identifiable, Equatable {
    let id: UUID
    let activity: ActivityItem
    let date: Date
    var timeSpend: Double
    let color: Color

    init(activity: ActivityItem, timeSpend: Double, date: Date) {
        id = UUID()
        self.activity = activity
        self.timeSpend = timeSpend
        self.date = date
        color = activity.color
    }
}

class TimeFrameData {
    var dataPoints: [DataPoint]
    var dataSeries: [DataSeriesPoint]
    let filterData: FilterData

    var timeSpendOnActivities: Double {
        var timeSpend: Double = 0
        for dp in dataPoints {
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
        dataSeries = []
        dataPoints = []

        for log in logs {
            insertLog(log: log)
            insertSeries(log: log)
        }
    }

    private func insertSeries(log: ActivityLog) {
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

        if var index = dataSeries.firstIndex(where: { point in
            point.date == dateToSave && point.activity == log.activity
        }) {
            // point found, do something with it
            dataSeries[index].timeSpend += endTime.timeIntervalSince(startTime)
        } else {
            dataSeries.append(DataSeriesPoint(activity: activity, timeSpend: endTime.timeIntervalSince(startTime), date: dateToSave))
        }
    }

    private func insertLog(log: ActivityLog) {
        var startTime = log.startTime ?? filterData.startDate
        var endTime = log.endTime ?? filterData.endDate

        guard let activity = log.activity else { return }

        if startTime < filterData.startDate {
            startTime = filterData.startDate
        }
        if endTime > filterData.endDate {
            endTime = filterData.endDate

            print("new end")
            print(endTime)
        }

        guard endTime > startTime else { return }

        if let index = dataPoints.firstIndex(where: { DataPoint in
            DataPoint.activity == activity
        }) {
            dataPoints[index].timeSpend += endTime.timeIntervalSince(startTime)

        } else {
            dataPoints.append(DataPoint(activity: activity, timeSpend: endTime.timeIntervalSince(startTime), filterData: filterData))
        }
    }
}
