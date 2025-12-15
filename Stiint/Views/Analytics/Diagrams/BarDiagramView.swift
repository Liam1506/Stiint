//
//  BarDiagramView.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import SwiftUI
import Charts


struct BarDiagramView: View {
    
    let filterData: FilterData
    
    private func updateSancy(){
        let calendar = Calendar.current
        let now = Date()
        
        // 1. Get the start of Today (00:00:00 this morning)
        let startOfToday = calendar.startOfDay(for: now)
        
        // 2. End Date: Subtract 1 second to get 23:59:59 of Yesterday
        let endOfYesterday = startOfToday.addingTimeInterval(-1)
        //let endOfToday = now
        // 3. Start Date: Go back 7 days from TODAY's start
        // This gives you the previous 7 full days (excluding today)
        let startOfSevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: startOfToday)!
        
        // 4. Call your function
        Task{
            let data = await AnalyticsDataProvider().loadDataForTimeFrame(
                start: filterData.startDate,
                end: filterData.endDate
            )
            
            let freeTimeActivity = Activity(id: UUID(), name: "Free Time", color: .accentColor)
            barChartData = data.dataPoints
            if(filterData.showFreeTime){
                
                barChartData.append(DataPoint(Activity: freeTimeActivity, timeSpend: data.timeOverall - data.timeSpendOnActivities))
            }
        }
    }
    
    
    @State var barChartData: [DataPoint] = []
    
    var body: some View {
        
        Chart(barChartData, id: \.activity.id) { element in
            BarMark(
                x: .value("Index", barChartData.firstIndex(where: { elem in
                    elem.activity.id == element.activity.id
                }) ?? 0),
                y: .value("Count", max(0, element.timeSpend)) // Prevent negative values
            )
            .foregroundStyle(by: .value("Name", element.activity.name ?? "error"))
        }
        .chartForegroundStyleScale(
            range: barChartData.map { $0.activity.color }
        )
        .chartYAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let time = value.as(Double.self) {
                        Text(TimeHandler().secondsToLocalizedDuration(time)) // Add "s" suffix
                    }
                }
                AxisGridLine()
                AxisTick()
            }
        }
        .chartXAxis(.hidden)
        .padding(15)
        .frame(height: 400)
        .background(.regularMaterial)
        .cornerRadius(30)
        .onAppear {
            updateSancy()
        }.onChange(of: filterData) { _, _ in
            updateSancy()
        }
    }
}


