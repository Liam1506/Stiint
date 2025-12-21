//
//  StartActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//
import Foundation
import AppIntents

struct StartSpecificActivity: LiveActivityIntent {
    static var title: LocalizedStringResource = "Start an activity"
    
    static var description: LocalizedStringResource = "Starts a specific activity, if the current date is selected."

    
    @Parameter(title: "Activity")
    var activity: ActivityEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Start \(\.$activity)")
    }
    
    func perform() async throws -> some IntentResult {
        
        let weekdays = await PersistenceManager.shared.activityActor.getActivityById(from: activity.id)!.weekdays ?? []
        
        if await weekdays.contains(.today) {
            await RunningManager.shared.startActivity(activityId: activity.id)
        }

        return .result()
    }
}


