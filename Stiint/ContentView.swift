//
//  ContentView.swift
//  Stiint
//
//  Created by Liam Wittig on 10.12.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    @State private var showAccessory = false

    @Environment(\.modelContext) private var modelContext
    var body: some View {
        TabView {
                  Tab("My Day", systemImage: "7.calendar") {
                      HomeView()
                  }

                  Tab("Timers", systemImage: "timer") {
                      TimerView()
                  }


                  Tab("Insights", systemImage: "chart.bar") {
                      AnalyticsView()
                  }
         
        
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
            .tabViewBottomAccessory() {
                TimerStatusView()
            }
        
       

        
   

    }


}

#Preview {
    ContentView()
}
