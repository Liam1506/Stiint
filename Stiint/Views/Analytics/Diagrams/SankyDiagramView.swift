//
//  SankyDiagramView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import Sankey
import SwiftUI

struct SankyDiagramView: View {
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
            sankeyData = calcSampleData(timeFrameData: data)
        }
    }
    
    
    private func calcSampleData(timeFrameData: TimeFrameData) -> SankeyData {
        
        var links: [SankeyLink] = []
        let keyFrom = "Avaible Time (24h)"
        let freeTimeKey = "Free Time"
        var nodes: [SankeyNode] = [SankeyNode(keyFrom, color: .blue),]
        
        for point in timeFrameData.dataPoints {
            
            var time: Double = 0
            if(point.timeSpend > 0){
                 time = point.timeSpend
                
                
            }else{
                
                time = point.timeSpend * -1
            }
            let name = "\(point.activity.name!) (\(TimeHandler().secondsToLocalizedDuration(time)))"
            nodes.append(SankeyNode(name, color: point.activity.color))
            links.append(SankeyLink(time, from: keyFrom, to: name))
        }
        
        if(filterData.showFreeTime){
            
            nodes.append(SankeyNode(freeTimeKey, color: .accentColor))
            print("Free time: \(timeFrameData.timeOverall - timeFrameData.timeSpendOnActivities)")
            links.append(SankeyLink((timeFrameData.timeOverall - timeFrameData.timeSpendOnActivities), from: keyFrom, to: freeTimeKey))
        }
        
        return SankeyData(nodes: nodes, links: links)
    }

    @State var sankeyData = SankeyData(
            nodes: [
            ],
            links: [
               
            ]
        )
    
    var body: some View {
        

        SankeyDiagram(sankeyData)
                .nodeOpacity(1)
                .linkColorMode(.target)
                .padding(15)
                .frame(height: 400)
                .background(.regularMaterial)
                .cornerRadius(30)
                .onAppear(){
                    updateSancy()
                }.onChange(of: filterData) { _, _ in
                    updateSancy()
                }
    }
}

