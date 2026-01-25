//
//  ContentView.swift
//  Stiint
//
//  Created by Liam Wittig on 10.12.25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var subscriptionManager = SubscriptionManager.shared
    @AppStorage("pauseTracking") private var pauseTracking: Bool = false

    @State private var showAccessory = false

    @Environment(\.modelContext) private var modelContext
    
    var todayCalendarIcon: String {
        let day = Calendar.current.component(.day, from: Date())
        return "\(day).calendar"
    }
    
    var body: some View {
        TabView {
            Tab("My Day", systemImage: todayCalendarIcon) {
                if pauseTracking {
                    TrackingPausedView()
                } else {
                    HomeView()
                }
            }

            Tab("Timers", systemImage: "timer") {
                if pauseTracking {
                    TrackingPausedView()
                } else {
                    TimerView()
                }
            }

            Tab("Insights", systemImage: "chart.bar") {
                AnalyticsView()
            }

            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .tabViewBottomAccessory(isEnabled: RunningManager.shared.activityDTO != nil, content: {
            TimerStatusView()
        })
            .sheet(isPresented: $subscriptionManager.displayPaywall) {
            PaywallView()
        }
    }
}

#Preview {
    ContentView()
}
