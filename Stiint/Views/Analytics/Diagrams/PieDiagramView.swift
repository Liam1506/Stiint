//
//  SankyDiagramView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import SwiftUI
import Charts

struct PieDiagramView: View {
    
    let data: TimeFrameData
    
    let filterData: FilterData
    
    
    private func updateSancy(){

        Task{
 
            
            let freeTimeActivity = ActivityItem(id: UUID(), name: "Free Time", color: .accentColor)
            pieChartData = data.dataPoints
                
                pieChartData.append(DataPoint(activity: freeTimeActivity, timeSpend: data.timeOverall - data.timeSpendOnActivities, filterData: filterData))
            }
        }
    


    @State var pieChartData: [DataPoint] = []
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Avg. Time per Day")
                .font(.headline)
            Text("The diagram illustrates the average amount of time you spend each day over a given period as pie chart.")
                      .font(.footnote)
                      .foregroundStyle(.secondary)
                      .padding(.bottom, 10)
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
         
            .onAppear {
                updateSancy()
            }.onChange(of: data.dataPoints) { _, _ in
                
                    updateSancy()
            }
        }     .padding(15)
            .frame(height: 500)
            .background(.regularMaterial)
            .cornerRadius(12)
    }
}

