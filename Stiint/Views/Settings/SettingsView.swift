//
//  SettingsView.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var selectedDays: Set<Weekday> = []
     @State private var showDayPicker = false
     @State private var showInstructions = false
    
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
                    Section(header: Text("Tracked days")) {
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
                         
                        
                    }
                    
                    Button("Reset Setup"){
                        SetupManager.shared.resetSetup()
                    }
                }
            
            .navigationTitle("Settings")
        }.sheet(isPresented: $showDayPicker) {
            DayPickerView(
                selectedDays: $selectedDays
            )
        }       .sheet(isPresented: $showInstructions) {
            InstructionView()
          
        }
    }
}

#Preview {
    SettingsView()
}
