//
//  AnalyticsView.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI

struct AnalyticsView: View {
    
    @State private var currentFilter: FilterData?
    
    var body: some View {
        NavigationView{
            
            ScrollView{
                AnalyticsFilterView { filterData in
                          currentFilter = filterData
                          print("Filter applied in AnalyticsView:")
                          print("- Date Range: \(filterData.startDate) to \(filterData.endDate)")
                          print("- Show Free Time: \(filterData.showFreeTime)")
                          print("- Selected Activities: \(filterData.selectedActivityIds.count)")
                      }
                      .padding(.horizontal)
                if currentFilter != nil {
                    SankyDiagramView(filterData: currentFilter!).padding()
                    PieDiagramView(filterData: currentFilter!).padding()
                    BarDiagramView(filterData: currentFilter!).padding()
                }
       
                
            }
            .navigationTitle("Insights")
           
        }
        
    }
}

#Preview {
    AnalyticsView()
}
