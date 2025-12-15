//
//  InstructionView.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import SwiftUI

enum AutomationType: String, CaseIterable, Identifiable {
    case appOpen = "App Open"
    case appClose = "App Closed"
    case locationEnter = "Arrive"
    case locationLeave = "Leave"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .appOpen: return "When App Opens"
        case .appClose: return "When App Closes"
        case .locationEnter: return "Arrive at Location"
        case .locationLeave: return "Leave Location"
        }
    }
}

struct InstructionView: View {
    
    @State private var selectedType: AutomationType = .appClose
    
       @Environment(\.dismiss) private var dismiss
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Selector for the 4 Versions
                    Picker("Automation Type", selection: $selectedType) {
                        ForEach(AutomationType.allCases) { type in
                            Text(type.title).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 10)
                    
                    // 1. Introduction
                    IntroSection(type: selectedType)
                    
                    Divider()
                    
                    // 2. Step-by-Step Guide
                    StepsSection(type: selectedType)
                    
                    // 3. Action Button
                    OpenShortcutsButton()
                }
                .padding()
            }    .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Automation Setup")
        }
    }
    
}

// MARK: - View Components

private extension InstructionView {
    
    struct IntroSection: View {
        let type: AutomationType
        
        var introText: LocalizedStringKey {
            switch type {
            case .appOpen:
                return "Automatically **start** or **stop** an activity when you **open** a specific app (e.g., Start 'Work' when you open 'Slack')."
            case .appClose:
                return "Automatically **start** or **stop** an activity when you **close** a specific app (e.g., Stop 'Social' when you close 'Instagram')."
            case .locationEnter:
                return "Automatically **start** an activity when you **arrive** at a specific location (e.g., Start 'Gym' when you arrive at the fitness center)."
            case .locationLeave:
                return "Automatically **stop** an activity when you **leave** a specific location (e.g., Stop 'Work' when you leave the office)."
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Integrate **Stiint** with Shortcuts.")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(introText)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(alignment: .center) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .padding(.top, 2)
                    Text("Prerequisite: Ensure the **Shortcuts** app is installed.")
                        .font(.subheadline)
                }
                .padding(.top, 5)
            }
        }
    }
    
    struct StepsSection: View {
        let type: AutomationType
        
        var body: some View {
            VStack(alignment: .leading, spacing: 25) {
                
                Text("Follow these steps:")
                    .font(.headline)
                
                // Step 1 is the same for all
                InstructionStep(
                    step: 1,
                    title: "Create Automation",
                    description: "Open Shortcuts, tap **Automation**, tap **+**, and select **'Create Personal Automation'**."
                )
                
                // Step 2 Changes based on Type
                switch type {
                case .appOpen:
                    InstructionStep(
                        step: 2,
                        title: "Select Trigger",
                        description: "Scroll down and select **App**. Choose your app, check **'Is Opened'**, and uncheck 'Is Closed'. Select **'Run Immediately'**."
                    )
                case .appClose:
                    InstructionStep(
                        step: 2,
                        title: "Select Trigger",
                        description: "Scroll down and select **App**. Choose your app, check **'Is Closed'**, and uncheck 'Is Opened'. Select **'Run Immediately'**."
                    )
                case .locationEnter:
                    InstructionStep(
                        step: 2,
                        title: "Select Trigger",
                        description: "Select **Arrive**. Choose your **Location** and adjust the radius. Select **'Run Immediately'** if available."
                    )
                case .locationLeave:
                    InstructionStep(
                        step: 2,
                        title: "Select Trigger",
                        description: "Select **Leave**. Choose your **Location** (e.g., Work). Select **'Run Immediately'** if available."
                    )
                }
                
                // Step 3
                InstructionStep(
                    step: 3,
                    title: "Add Stiint Action",
                    description: "Search for **Stiint**. Select an action like **'Start Activity'** or **'Stop Current Activity'**."
                )
                
                // Step 4
                InstructionStep(
                    step: 4,
                    title: "Finish",
                    description: "Tap **Done**. Your automation will now run automatically when the condition is met!"
                )
            }
        }
    }
    
    struct InstructionStep: View {
        let step: Int
        let title: LocalizedStringKey
        let description: LocalizedStringKey
        
        var body: some View {
            HStack(alignment: .top, spacing: 15) {
                Text("\(step)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    struct OpenShortcutsButton: View {
        @Environment(\.openURL) var openURL
        
        var body: some View {
            VStack {
                Spacer().frame(height: 10)
                Button(action: {
                    openAutomationPage()
                }) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Open Shortcuts App")
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    InstructionView()
}
