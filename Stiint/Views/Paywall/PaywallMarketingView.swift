//
//  PaywallMarketingView.swift
//  Stiint
//
//  Created by Liam Wittig on 10.01.26.
//
import SwiftUI

struct PaywallMarketingView: View {
    var body: some View {
        // Benefits List
        VStack(alignment: .leading, spacing: 25) {
            Text("Unlock all features")
                .font(.system(size: 28, weight: .bold))
            // 1. Unlimited Activities (The core current value)
            BenefitRow(
                icon: "infinity",
                title: "Unlimited Activities",
                description: "Track every aspect of your life without limits. Log as many custom categories as you need.",
                avaible: true
            )

            // 2. All Analyses (The data value)
            BenefitRow(
                icon: "chart.bar.xaxis",
                title: "Advanced Analytics",
                description: "Unlock deep-dive reports and historical trends to see exactly how your time distribution changes over weeks and months.",
                avaible: true
            )

            // 3. The "Future Insight" Hint (The investment value)
            BenefitRow(
                icon: "sparkles",
                title: "Intelligence Engine",
                description: "Get early access to upcoming AI-driven insights that will automatically find patterns and suggest optimizations for your day.",
                avaible: false
            )
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    let avaible: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                    if !avaible {
                        Text("Coming soon")
                            .font(.system(size: 10, weight: .bold))
                            .textCase(.uppercase) // Uppercase makes badges look more official
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(Capsule())
                            .foregroundStyle(Color.accentColor)
                    }
                }

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    PaywallMarketingView()
}
