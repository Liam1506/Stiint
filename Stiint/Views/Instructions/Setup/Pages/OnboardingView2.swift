import SwiftUI

struct OnboardingView2: View {
    @Binding var index: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Illustration
            Image(systemName: "moon.stars.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.indigo.gradient)
            
            // Title
            Text("Create a Sleep Activity")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .multilineTextAlignment(.leading)
            // Description
            Text(
                "Stiint doesn’t track your sleep automatically.\n\n" +
                "You’ll create a simple Apple Shortcut Automation that tells Stiint when you go to sleep and wake up.\n\n" +
                "We’ll guide you step by step. It only takes a minute."
            )
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: {
                    index += 1
                    Task{
                       await PersistenceManager.shared.activityActor.addActivity(name: "Sleep",color: .indigo, icon: "bed.double.fill")
                    }
                }) {
                    Text("Set Up Sleep Shortcut")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                // Optional trust line
                Text("No health permissions required. Data tracked using this App will never leave your device or iCloud.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(height: 50)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
