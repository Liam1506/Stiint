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
        
        let startOfToday = calendar.startOfDay(for: now)

        
        // 4. Call your function
        Task{
            let data = await AnalyticsDataProvider().loadDataForTimeFrame(
                filterData: filterData            )
            barChartData = data.dataPoints

        }
    }
    
    
    @State var barChartData: [DataPoint] = []
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Avg. Time per Day")
                .font(.headline)
            Text("The diagram illustrates the average amount of time you spend each day over a given period.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 10)
            Chart(barChartData, id: \.activity.id) { element in
                BarMark(
                    x: .value("Index", barChartData.firstIndex(where: { elem in
                        elem.activity.id == element.activity.id
                    }) ?? 0),
                    y: .value("Count", max(0, element.timeAvg)) // Prevent negative values
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
          
            .onAppear {
                updateSancy()
            }.onChange(of: filterData) { _, _ in
                updateSancy()
            }
        }  .padding(15)
            .frame(height: 500)
            .background(.regularMaterial)
            .cornerRadius(12)
    }
}


