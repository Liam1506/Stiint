//
//  SetupManagerView.swift
//  Stiint
//
//  Created by Wittig, Liam on 19.12.25.
//

import SwiftUI

struct SetupManagerView: View {
    @State private var index = 0

    var pages: [AnyView] {
        [
            AnyView(OnboardingView1(index: $index)),
            AnyView(OnboardingView2(index: $index)),
            AnyView(OnboardingView3(index: $index)),
            AnyView(OnboardingView4(index: $index))
        ]
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            TabView(selection: $index) {
                ForEach(pages.indices, id: \.self) { i in
                    pages[i]
                        .tag(i)
                        .ignoresSafeArea() // optional: makes pages fullscreen
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Skip button at top right
            Button(action: {
                SetupManager.shared.completeSetup()
            }) {
                Text("Skip")
                    .padding()
            }
        }
    }
}


protocol OnboardingPage: View {
    static var index: Int { get }
}
