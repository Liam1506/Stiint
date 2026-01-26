//
//  GetCurrentActivity.swift
//  Stiint
//
//  Created by Wittig, Liam on 20.12.25.
//

import AppIntents
import Foundation

// Define the result struct that will be returned by the intent

// Define the App Intent
struct GetCurrentActivity: AppIntent {
    static var title: LocalizedStringResource = "Get current activity"
    static var description = IntentDescription(
        "Retrieves the activity that is currently running. If no activity is active, this will return nil."
    )

    func perform() throws -> some IntentResult & ReturnsValue<ActivityEntity?>  {
        if let activity = DtoManager.shared.activityDTO {
            let result = ActivityEntity(id: activity.id, name: activity.name, startDate: activity.startTime)

            return .result(value: result)
        }

        return .result(value: nil)
    }
}
