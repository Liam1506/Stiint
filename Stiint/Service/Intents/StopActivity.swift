//
//  StopActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation
import AppIntents

struct StopActivity: LiveActivityIntent {
    static var title: LocalizedStringResource = "Stop the current activity"
    
    
    
        
    func perform() async throws -> some IntentResult {
        // Use the selected activity
        // QuickActionHandler.shared.performAction(selected: activity.id)
        
        Task{
         await
            RunningManager.shared.stopActivity()}
        
        return .result()
    }
}
