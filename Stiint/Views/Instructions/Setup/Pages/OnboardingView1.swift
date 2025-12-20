//
//  OnboardingView1.swift
//  Stiint
//
//  Created by Wittig, Liam on 19.12.25.
//

import SwiftUI

struct OnboardingView1: View {
    @Binding var index: Int

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Illustration or symbol
            Image(systemName: "clock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundStyle(.blue.gradient)

            // Title
            Text("Start Tracking Your Time")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            // Description
            Text("Thanks for downloading Stiint! We'll help you track your activities, hand off tasks efficiently, and make the most of your day.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // Action + legal
            VStack(spacing: 16) {
                Button(action: {
                    index += 1
                }) {
                    Text("Let's Start")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }

                // Privacy / Terms text with tappable links
                VStack(spacing: 4) {
                    Text("By continuing, you agree to our")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    HStack(spacing: 4) {
                        Link("Privacy Policy", destination: URL(string: "https://stiint.liamwittig.de/privacy.html")!)
                        Text("and")
                            .foregroundColor(.secondary)
                        Link("Terms of Service", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    }
                    .font(.footnote)
                }
                
                .frame(height: 50)
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
