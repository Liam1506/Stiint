//
//  DetailsDiagramView.swift
//  Stiint
//
//  Created by Wittig, Liam on 16.12.25.
//

import SwiftUI

struct DetailsDiagramView: View {
    
    @State private var sortOrder = [KeyPathComparator(\DataPoint.timeSpend)]
    let data: [DataPoint]
    var body: some View {
       NavigationView {
           Table(data, sortOrder: $sortOrder) {
                      TableColumn("Activity", value: \.activity.name!)
                      TableColumn("Time Spent", value: \.timeSpend) { dataPoint in
                          Text(String(format: "%.1f hrs", dataPoint.timeSpend))
                      }
                      TableColumn("Daily Avg", value: \.timeAvg) { dataPoint in
                          Text(String(format: "%.2f hrs", dataPoint.timeAvg))
                      }
                      TableColumn("Start Date", value: \.startDate) { dataPoint in
                          Text(dataPoint.startDate, format: .dateTime.month().day())
                      }
                      TableColumn("End Date", value: \.endDate) { dataPoint in
                          Text(dataPoint.endDate, format: .dateTime.month().day())
                      }
                  }
        }
    }
}

