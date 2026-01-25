//
//  StopActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import AppIntents
import Foundation

struct StopActivity: AppIntent {
    static var title: LocalizedStringResource = "Stop the current activity"

    // Optional description of the intent
    static var description: LocalizedStringResource = "Stops the currently running activity."

    func perform() async throws -> some IntentResult {
        // Use the selected activity
        // QuickActionHandler.shared.performAction(selected: activity.id)

        await RunningManager.shared.stopActivity()
        

        return .result()
    }
}
