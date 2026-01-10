
//
//  BarDiagramView.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import SwiftUI
import Charts


struct LineDiagramView: View {
    let calendar = Calendar.current
  
    
    let data: TimeFrameData
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Daily Time Spent")
                .font(.headline)
            Text("Each point represents the total time spent on activities for that day over the selected period.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 10)
            if(data.dataSeries.isEmpty == false){
                
                
                Chart {
                    ForEach(data.dataSeries) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Time Spent", point.timeSpend)
                        )
                        .foregroundStyle(by: .value("Activity", point.activity.name!)) // separate line for each activity
                        .symbol(by: .value("Activity", point.activity.name!)) // optional: different symbols for points
                    }
                }

                .chartYScale(domain: 0...data.dataSeries.map { $0.timeSpend }.max()!)
                .chartForegroundStyleScale(
                    range: data.dataSeries.map { $0.activity.color }
                )
                .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisValueLabel {
                                    if let time = value.as(Double.self) {
                                        Text(TimeHandler().secondsToLocalizedDuration(time))
                                    }
                                }
                            }
                        }
              
            }else{
                ContentUnavailableView("Nothing to display", systemImage: "questionmark.app")
            }
            
        }  .padding(15)
            .frame(height: 400)
            .background(.regularMaterial)
            .cornerRadius(12)
           

    }
}



