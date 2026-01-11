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
                TableColumn("Activity") { item in
                    Text(item.activity.name ?? "Unknown")
                }
                .width(min: 100)

                TableColumn("Time Spent") { item in
                    Text("\(Int(item.timeSpend)) min")
                }
                .width(min: 80)

                TableColumn("Avg/Day") { item in
                    Text(String(format: "%.1f min/day", item.timeAvg))
                }
                .width(min: 80)
            }
            .navigationTitle("Activity Details")
        }
    }
}
