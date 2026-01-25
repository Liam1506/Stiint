//
//  SettingsView.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import StoreKit
import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var selectedDays: Set<Weekday> = []
    @State private var showDayPicker = false
    @State private var showInstructions = false

    @State private var showingManageSubscriptions = false
    @State private var showAcknowledgement = false

    @Query(sort: \ActivityLog.startTime) private var logs: [ActivityLog]

    @Environment(\.requestReview) var requestReview

    @AppStorage(
        "enableLiveActivities"
    ) private var liveActivitiesEnabled: Bool = false

    @AppStorage("pauseTracking") private var pauseTracking: Bool = false

    private var trackedDaysText: String {
        if selectedDays.isEmpty {
            return "None"
        }

        return selectedDays
            .sorted { $0.rawValue < $1.rawValue }
            .map { $0.shortTitle }
            .joined(separator: ", ")
    }

    var body: some View {
        NavigationView {
            Form {
               /* Button("Request Location"){
                    LocationManager().requestAuthorization()
                }
                
                Button("Get Location"){
                    Task{
                        let location = try? await LocationManager().getCurrentLocation()
                        print(location)
                    }
                   //
                }
                if(LocationManager().locationAvailable){
                    Text("Avaible")
                }*/
                if(!SubscriptionManager.shared.isPro){
                    Section {
                        Button {
                            SubscriptionManager.shared.showPaywall()
                        } label: {
                            HStack {
                                Text("Get Stiint")
                                
                                    Text(" Plus ")     .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.blue, lineWidth: 1.5)
                                    )
                                    .font(.headline)
                                
                                
                          
                            }
                        }
                    }

                }
                
                Section {
                    Toggle("Pause Tracking", isOn: $pauseTracking)
                        .onChange(of: pauseTracking) { _, newValue in
                            if newValue == true {
                                Task {
                                    await RunningManager.shared.stopActivity()
                                }
                            }
                        }
                }

                Section(header: Text("Help")) {
                    
                
                    Button("Tutorial") {
                        SetupManager.shared.resetSetup()
                    }
                    Button("How to create an Automation") {
                        showInstructions = true
                    }
                    Link(
                        "Further Support",
                        destination: URL(string: HELP_LINK)!
                    )
                }
                
                
                

                Section(header: Text("Data Export")) {
                    
                    NavigationLink("Export") {
                        RawDataView(logs: logs)
                    }
                }
                
                Section(header: Text("Info")) {
                    Button("Review the app") {
                        requestReview()
                    }
                    if(SubscriptionManager.shared.isPro){
                        Button("Manage Subscriptions") {
                            showingManageSubscriptions.toggle()
                        }
                    }else{
                        Button("Restore purchases") {
                            Task{
                                try await AppStore.sync()
                            }
                        }
                    }
                    Link(
                        "Terms of Service",
                        destination: URL(string: TERMS_OF_SERVICE_LINK)!
                    )
                    Link(
                        "Privacy Policy",
                        destination: URL(string: PRIVCY_POLICY_LINK)!
                    )

                    Button("Acknowledgements") {
                        showAcknowledgement.toggle()
                    }
                }
            }

            .navigationTitle("Settings")
        }.sheet(isPresented: $showDayPicker) {
            DayPickerView(
                selectedDays: $selectedDays
            )
        }.sheet(isPresented: $showInstructions) {
            InstructionView()
        }
        .sheet(isPresented: $showAcknowledgement) {
            AcknowledgementsView()
        }
        .manageSubscriptionsSheet(
            isPresented: $showingManageSubscriptions,
            subscriptionGroupID: PLUS_GROUP_ID
        )
    }
}

#Preview {
    SettingsView()
}
