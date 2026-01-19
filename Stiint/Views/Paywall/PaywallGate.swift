//
//  PaywallGate.swift
//  Stiint
//
//  Created by Liam Wittig on 18.01.26.
//

import SwiftUI

struct PaywallGate<Content: View>: View {
    let isPremium: Bool
    let action: () -> Void
    let content: Content

    init(
        isPremium: Bool,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isPremium = isPremium
        self.action = action
        self.content = content()
    }

    var body: some View {
        ZStack {
            content
                .disabled(!isPremium)
                .blur(radius: isPremium ? 0 : 6)
                .opacity(isPremium ? 1 : 0.4)

            if !isPremium {
                VStack(spacing: 12) {
                    Text("Stiint Plus")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Button(action: action) {
                        Text("Try for free")
                            .font(.headline)
                            .padding(12)
                            .glassEffect()
                            .shadow(
                                color: Color.blue.opacity(0.35),
                                radius: 12,
                                x: 0,
                                y: 6
                            )
                    }
                }
                .padding()            }
        }
    }
}
