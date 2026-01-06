//
//  SettingsView.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @State private var selectedDays: Set<Weekday> = []
     @State private var showDayPicker = false
     @State private var showInstructions = false
    
    @State private var showAcknowledgement = false
    
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
                    /*Section(header: Text("Tracked days")) {
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
                         
                        
                    }*/
                    Section{
                        
                        Toggle("Pause Tracking", isOn: $pauseTracking).onChange(of: pauseTracking) { oldValue, newValue in
                            if (newValue == true){
                                Task{
                                    await RunningManager.shared.stopActivity()
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Help")){
                        Button("Tutorial"){
                            SetupManager.shared.resetSetup()
                        }
                        Button("How to create an Automation") {
                            showInstructions = true
                        }
                        Link("Further Support", destination: URL(string: HELP_LINK)!)
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
