//
//  StartActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//
import Foundation
import AppIntents

struct StopSpecificActivity: AppIntent {
    static var title: LocalizedStringResource = "Stop a specific Activity"
    
    @Parameter(title: "Activity")
    var activity: ActivityEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Stop \(\.$activity) if running")
    }
    
    func perform() async throws -> some IntentResult {
        // Use the selected activity
        // QuickActionHandler.shared.performAction(selected: activity.id)
        
        Task{
         await
            RunningManager.shared.startActivity(activityId: activity.id)
        }
        
        return .result()
    }
}


