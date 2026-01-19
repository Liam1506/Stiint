//
//  StartActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//
import AppIntents
import Foundation

struct StopSpecificActivity: LiveActivityIntent {
    static var title: LocalizedStringResource = "Stop a specific activity"

    static var description: LocalizedStringResource = "Stops the selected activity. Any other running activity will remain unaffected."

    @Parameter(title: "Activity")
    var activity: ActivityEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Stop \(\.$activity) if running")
    }

    func perform() async throws -> some IntentResult {
        // Use the selected activity
        // QuickActionHandler.shared.performAction(selected: activity.id)

        await
            RunningManager.shared.stopSpecificActivity(activityId: activity.id)

        return .result()
    }
}
