//
//  TimerStatusView.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import SwiftUI

struct TimerStatusView: View {
    var body: some View {
        if let activity = RunningManager.shared.activityDTO {
            HStack {
                Image(systemName: activity.icon)

                Text(activity.name)

                Spacer()

                Text(activity.startTime, style: .timer)
                    .font(.headline.monospaced())
            }
            .padding()
        }
    }
}

#Preview {
    TimerStatusView()
}
