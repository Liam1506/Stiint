//
//  GetCurrentActivity.swift
//  Stiint
//
//  Created by Wittig, Liam on 20.12.25.
//

import AppIntents
import Foundation
import SwiftData

// Define the result struct that will be returned by the intent


// Define the App Intent
struct GetAllActivities: AppIntent {
    static var title: LocalizedStringResource = "Get all available Activities"
    static var description = IntentDescription(
        "Get all available activites."
    )

    
    func perform() async throws -> some IntentResult & ReturnsValue<[ActivityEntity]> {

        var activities: [ActivityEntity] = []
        let allActivites = await PersistenceManager.shared.activityActor.getAllAvaibleActivitys()
        for  activity in allActivites {
            if activity.isDeleted != true {
                activities.append(ActivityEntity(id: activity.id!, name: activity.name ?? "No name avaible"))
            }
        }
        
        
        return .result(value: activities)
    }
}
