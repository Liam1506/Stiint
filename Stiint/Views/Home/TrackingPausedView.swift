//
//  TrackingPausedView.swift
//  Stiint
//
//  Created by Liam Wittig on 06.01.26.
//

import SwiftUI

struct TrackingPausedView: View {
    
    var body: some View {
        ContentUnavailableView(
            "Tracking Paused",
            systemImage: "beach.umbrella.fill",
            description: Text("Tracking is currently paused. This means that no activities will be triggered. You can unpause tracking in the settings.")
        )

    }
}

#Preview {
    TrackingPausedView()
}
