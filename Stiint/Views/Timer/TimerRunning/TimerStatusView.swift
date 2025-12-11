//
//  TimerStatusView.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import SwiftUI

struct TimerStatusView: View {
    var body: some View {
        if(RunningManager.shared.activityDTO != nil){
            HStack {
                Image(systemName: "car.fill")
                Text(RunningManager.shared.activityDTO!.startTime, style: .timer)
                    .font(.headline)
                Spacer()
                Text(RunningManager.shared.activityDTO!.name)
            }
            .padding()
        }
    }
}

#Preview {
    TimerStatusView()
}
