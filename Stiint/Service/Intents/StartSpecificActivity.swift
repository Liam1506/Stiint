//
//  StartActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//
import Foundation
import AppIntents

struct StartSpecificActivity: LiveActivityIntent {
    static var title: LocalizedStringResource = "Start an Activity"
    
    static var description: LocalizedStringResource = "Starts a specific activity, if the current date is selected."

    
    @Parameter(title: "Activity")
    var activity: ActivityEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Start \(\.$activity)")
    }
    
    func perform() async throws -> some IntentResult {
        await RunningManager.shared.startActivity(activityId: activity.id)
            
        return .result()
    }
}
