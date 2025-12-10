//
//  StopActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation
import AppIntents

struct StopActivityAndResumePrevious: AppIntent {
    static var title: LocalizedStringResource = "Stop the and current activity and resume the previous activity"

    func perform() async throws -> some IntentResult {
        
        Task{
                await RunningManager.shared.stopAndStartPreviousActivity()
            }
        
        return .result()
    }
}
