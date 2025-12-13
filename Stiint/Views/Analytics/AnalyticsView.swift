//
//  AnalyticsView.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        NavigationView{
            ScrollView{
                
                SankyDiagramView().padding()
            }
            .navigationTitle("Insights")
           
        }
        
    }
}

#Preview {
    AnalyticsView()
}
