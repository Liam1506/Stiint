//
//  ContentView.swift
//  Stiint
//
//  Created by Liam Wittig on 10.12.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        TabView {
                  Tab("My Day", systemImage: "7.calendar") {
                      HomeView()
                  }

                  Tab("Stints", systemImage: "timer") {
                      TimerView()
                  }


                  Tab("Insights", systemImage: "chart.bar") {
                      AnalyticsView()
                  }
            Tab(role: .search) {
                Text("Search")
            }
        }.tabViewBottomAccessory {
           // Text("test")
            if(RunningManager.shared.activityDTO != nil){
                 
                HStack{
                    Image(systemName: "car.fill")
                    Text(RunningManager.shared.activityDTO!.startTime, style: .timer).font(Font.headline)
                    Spacer()
                    Text(RunningManager.shared.activityDTO!.name)
                }.padding()
            }
        }

    }


}

#Preview {
    ContentView()
}
