//
//  SettingsView.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import StoreKit
import SwiftUI

struct SettingsView: View {
    @State private var selectedDays: Set<Weekday> = []
    @State private var showDayPicker = false
    @State private var showInstructions = false

    @State private var showAcknowledgement = false

    @State private var csvURL: URL?

    @Environment(\.requestReview) var requestReview

    @AppStorage("enableLiveActivities") private var liveActivitiesEnabled: Bool = false

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
                /* Section(header: Text("Tracked days")) {
                 HStack{
                 VStack(alignment: .leading){
                 Text("Untracked days:")
                 Text(trackedDaysText).font(.subheadline)
                 .foregroundStyle(.secondary)
                 }
                 Spacer()
                 }

                 .contentShape(Rectangle())
                 .onTapGesture {

                 showDayPicker.toggle()
                 }
                 VStack {
                 Button("How to create an Automation") {
                 showInstructions = true
                 }
                 }
                 // This modifier presents the InstructionView as a sheet

                 } */

                Section {
                    Toggle("Pause Tracking", isOn: $pauseTracking).onChange(of: pauseTracking) { _, newValue in
                        if newValue == true {
                            Task {
                                await RunningManager.shared.stopActivity()
                            }
                        }
                    }
                }

                Section(header: Text("Help")) {
                    
                    if (PAYWALL){
                        
                    
                    Button("Paywall"){
                        SubscriptionManager.shared.showPaywall()
                    }
                    Text("Is PRO enabled? \(SubscriptionManager.shared.isPro ? "Yes" : "No")")
                    
                    Button("Restore purchases") {
                        Task{
                            try await AppStore.sync()
                        }
                    }
                }
                    Button("Tutorial") {
                        SetupManager.shared.resetSetup()
                    }
                    Button("How to create an Automation") {
                        showInstructions = true
                    }
                    Link("Further Support", destination: URL(string: HELP_LINK)!)
                }

                Section(header: Text("Data Export")) {
                    Button("Export my activities") {
                        Task {
                            do {
                                csvURL = try await CsvHandler().exportDataAsCsv()
                            } catch {
                                //                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    if let csvURL = csvURL {
                        ShareLink(
                            item: csvURL,
                            preview: SharePreview(
                                "Data Export",
                                image: Image(systemName: "tablecells")
                            )
                        ) {
                            Text("Save CSV")
                        }
                    }
                }

                Section(header: Text("Info")) {
                    Button("Review the app") {
                        requestReview()
                    }
                    Link("Terms of Service", destination: URL(string: TERMS_OF_SERVICE_LINK)!)
                    Link("Privacy Policy", destination: URL(string: PRIVCY_POLICY_LINK)!)

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
    }
}

#Preview {
    SettingsView()
}
