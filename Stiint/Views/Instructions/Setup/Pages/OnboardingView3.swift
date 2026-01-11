import SwiftUI

struct OnboardingView3: View {
    @Binding var index: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Illustration
                Image(systemName: "moon.stars.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(.indigo.gradient)

                // Title
                Text("Set Up sleep")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Introduction
                Text("Learn how to track your sleep by creating a Sleep activity. Follow these simple steps to get started and improve your nightly routine.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Steps
                VStack(alignment: .leading, spacing: 20) {
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
                        title: "Select the Sleep automation from the list",
                        descriptions: [],
                        buttonTitle: nil,
                        buttonAction: nil,
                        imageName: "sleepSelect"
                    )

                    StepView(
                        number: 3,
                        title: "Select the right conditon",
                        descriptions: [
                            "Select 'Bedtime Begins' as the condition. Make sure to select 'Run Immediately' so you don’t have to confirm every time the shortcut runs.",

                            "You might need to set up Screen Time first in the Apple Health app. If you prefer not to, you can choose the 'Time of Day' trigger on the previous page.",
                        ],
                        buttonTitle: "Setup Sleep in Apple Health",
                        buttonAction: {
                            if let url = URL(string: "https://support.apple.com/guide/iphone/iphaf56dceb4/ios") {
                                UIApplication.shared.open(url)
                            }
                        },
                        imageName: "selectOption"
                    )

                    StepView(
                        number: 4,
                        title: "Create a new shortcut that runs the automation",
                        descriptions: ["Tap the 'Create New Shortcut' button in the top left."],
                        buttonTitle: nil,
                        buttonAction: nil,
                        imageName: "createNewShortcut"
                    )

                    StepView(
                        number: 5,
                        title: "Select the 'Start an Activity' intent",
                        descriptions: ["Search for the action named 'Stiint' to find the correct shortcut and select it."],
                        buttonTitle: nil,
                        buttonAction: nil,
                        imageName: "startAnActivityIntent"
                    )

                    StepView(
                        number: 6,
                        title: "Ensure the 'Sleep' activity is selected",
                        descriptions: ["If not, make sure, to select it from the list."],
                        buttonTitle: nil,
                        buttonAction: nil,
                        imageName: "selectSleepInShortcuts"
                    )

                    Text("Now, the sleep activity is set up, to start. In the enxt step, you learn how to stop it automaticly")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)

                // Action Button
                Button(action: {
                    index += 1
                }) {
                    Text("Got it, go on")
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

// MARK: - Reusable Step View

struct StepView: View {
    let number: Int
    let title: String
    let descriptions: [String]
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    let imageName: String?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.blue)
                .frame(width: 24, height: 24)
                .overlay(Text("\(number)").foregroundColor(.white))

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.body)

                ForEach(descriptions, id: \.self) { description in
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                    Button(buttonTitle, action: buttonAction)
                        .font(.body)
                        .padding(.vertical, 6)
                        .padding(.horizontal)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }

                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 180)
                        .padding(.top, 4)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
