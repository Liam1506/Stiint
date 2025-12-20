//
//  StopActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation
import AppIntents

struct StopSpecificActivityAndResumePrevious: AppIntent {
    static var title: LocalizedStringResource = "Stop the and current activity and resume the previous activity"
    
    static var description: LocalizedStringResource = "Stops the selected activity and resumes the previous activity, if available. The previous activity is only available if it was overwritten when starting the current activity. If no previous activity exists, the current activity will simply stop. If another activity is running, no action will be taken."

    
    @Parameter(title: "Activity")
    var activity: ActivityEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Stop \(\.$activity) if running and resume previous")
    }
    
    func perform() async throws -> some IntentResult {
         await
            RunningManager.shared.stopSpecificAndStartPreviousActivity(activityId: activity.id)
        
        
        return .result()
    }
}
