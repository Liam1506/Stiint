//
//  SankyDiagramView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import SwiftUI
import Charts

struct PieDiagramView: View {
    
    
    
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
                filterData: filterData
            )
            
            let freeTimeActivity = Activity(id: UUID(), name: "Free Time", color: .accentColor)
            pieChartData = data.dataPoints
            if(filterData.showFreeTime){
                
                pieChartData.append(DataPoint(activity: freeTimeActivity, timeSpend: data.timeOverall - data.timeSpendOnActivities, startDate: filterData.startDate, endDate: filterData.endDate))
            }
        }
    }


    @State var pieChartData: [DataPoint] = []
    
    var body: some View {
        
        Chart(pieChartData, id: \.activity.id) { element in
            SectorMark(
                angle: .value("Count", element.timeSpend),
                innerRadius: .ratio(0.6)
            )
            .foregroundStyle(by: .value("Name", element.activity.name ?? "error"))
        }
        .chartForegroundStyleScale(
            range: pieChartData.map { $0.activity.color }
        )
        .chartXAxis(.hidden)
                .padding(15)
                .frame(height: 400)
                .background(.regularMaterial)
                .cornerRadius(12)
                .onAppear {
                    updateSancy()
                }.onChange(of: filterData) { _, _ in
                    updateSancy()
                }
    }
}

