import SwiftUI

struct OnboardingView4: View {
    @Binding var index: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Stopping sleep")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("After learning how to start an activity, you will now learn how to stop one.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Steps
                VStack(spacing: 20) {
                    StepView(
                        number: 1,
                        title: "Open the Shortcut Automation Page",
                        descriptions: [],
                        buttonTitle: "Open Shortcut Automation Page",
                        buttonAction: openAutomationPage,
                        imageName: nil
                    )
                    
                    StepView(
                        number: 2,
                        title: "Select the automation you want to use",
                        descriptions: [
                            "Choose the option that best fits your day.",
                            "Select 'Alarm' if you use your phone as an alarm. Sleep tracking will stop when your alarm goes off.",
                            "Select 'Sleep' if you wear an Apple Watch or want to stop sleep tracking at a specific time."
                        ],
                        buttonTitle: nil,
                        buttonAction: nil,
                        imageName: "sleepSelect"
                    )
                    
                    StepView(
                        number: 3,
                        title: "Create a new shortcut that runs the automation",
                        descriptions: [
                            "Tap the 'Create New Shortcut' button in the top left."
                        ],
                        buttonTitle: nil,
                        buttonAction: nil,
                        imageName: "createNewShortcut"
                    )
                    
                    StepView(
                        number: 4,
                        title: "Select the 'Stop any Activity' intent",
                        descriptions: [
                            "Search for the action named 'Stiint' to find the correct shortcut and select it.",
                            "When this intent is triggered, any running activity will be stopped."
                        ],
                        buttonTitle: nil,
                        buttonAction: nil,
                        imageName: "startAnActivityIntent"
                    )
                    
                    Text("Now you know how to create and trigger automation. You can model your day in as much detail as you want. Further steps could include creating a work activity that automatically starts and stops when you arrive at and leave work.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                
                // Action Button
                Button(action: {
                    SetupManager.shared.completeSetup()
                }) {
                    Text("Finish setup")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
            }
            .padding()
        }
    }
}
