
//
//  BarDiagramView.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import SwiftUI
import Charts


struct AreaDiagramView: View {
    
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
                        AreaMark(
                            x: .value("Date", point.date),
                            y: .value("Time Spent", point.timeSpend),
                            stacking: .unstacked
                        )
                        .foregroundStyle(by: .value("Activity", point.activity.name!)) // separate line for each activity
                    }
                }

                .chartYScale(domain: 0...24*60*60)
                
                .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisValueLabel {
                                    if let time = value.as(Double.self) {
                                        Text(TimeHandler().secondsToLocalizedDuration(time))
                                    }
                                }
                                
                            }
                        }
                .chartForegroundStyleScale(
                    range: data.dataSeries.map { $0.activity.color }
                )
              
            }else{
                ContentUnavailableView("Nothing to display", systemImage: "questionmark.app")
            }
            
        }  .padding(15)
            .frame(height: 400)
            .background(.regularMaterial)
            .cornerRadius(12)

    }
}



