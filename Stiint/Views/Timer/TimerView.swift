//
//  TimerView.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        /*
         Two States:
         - Either to select an activty and start
         - The Timer itself, where you can stop the task
         */ if RunningManager.shared.running
        {
            TimerRunningView()
        } else {
            SelectActivity()
        }
    }
}

#Preview {
    TimerView()
}
