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
    @State var data: TimeFrameData?
    
    private func updateSancy(){
        Task{
             data = await AnalyticsDataProvider().loadDataForTimeFrame(
               filterData: filterData
            )
            sankeyData = calcSampleData(timeFrameData: data!)
        }
    }
    
    
    private func calcSampleData(timeFrameData: TimeFrameData) -> SankeyData {
        
        var links: [SankeyLink] = []
        let day: Double = 24 * 60 * 60
        let keyFrom = "Avaible Time (\(TimeHandler().secondsToLocalizedDuration(timeFrameData.timeOverallAvg)))"
        
        var nodes: [SankeyNode] = [SankeyNode(keyFrom, color: .blue),]
        
        for point in timeFrameData.dataPoints {
            
            var time: Double = 0
            if(point.timeSpend > 0){
                 time = point.timeAvg
                
                
            }else{
                
                time = point.timeAvg * -1
            }
            let name = "\(point.activity.name!) (\(TimeHandler().secondsToLocalizedDuration(time)))"
            nodes.append(SankeyNode(name, color: point.activity.color))
            links.append(SankeyLink(time, from: keyFrom, to: name))
        }
        let freeTimeKey = "Free Time (\(TimeHandler().secondsToLocalizedDuration(day - timeFrameData.timeSpendOnActivitiesAvg)))"
        if(filterData.showFreeTime){
            
            nodes.append(SankeyNode(freeTimeKey, color: .accentColor))
            print("Free time: \(timeFrameData.timeOverall - timeFrameData.timeSpendOnActivitiesAvg)")
         
            links.append(SankeyLink(day - timeFrameData.timeSpendOnActivitiesAvg, from: keyFrom, to: freeTimeKey))
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
        
        VStack(alignment: .leading){
            Text("Avg. Time per Day")
                .font(.headline)
            Text("The diagram illustrates the average amount of time you spend each day over a given period.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            SankeyDiagram(sankeyData)
                .nodeOpacity(1)
                .linkColorMode(.target)
                .frame(height: 400)
            NavigationLink("Learn more"){
                if(data != nil){
                    DetailsDiagramView(data:  data!.dataPoints)
                }else{
                    Text("Data error")
                }
            
            }
        }
           
                .padding(15)
                .background(.regularMaterial)
                .cornerRadius(12)
                .onAppear(){
                    updateSancy()
                }.onChange(of: filterData) { _, _ in
                    updateSancy()
                }
    }
}

