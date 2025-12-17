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
    
    @Parameter(title: "Activity")
    var activity: ActivityEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Start \(\.$activity)")
    }
    
    func perform() async throws -> some IntentResult {
        // Use the selected activity
        // QuickActionHandler.shared.performAction(selected: activity.id)
        
        
        //await LiveActivityManager.shared.startLiveActivity(dto: RunningManager.shared.activityDTO!)
        
        await RunningManager.shared.startActivity(activityId: activity.id)
            
        
        
        
        
        
        return .result()
    }
}

// Dynamic Entity that loads from PersistenceManager
struct ActivityEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Activity"
    }
    
    var id: UUID
    var name: String
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static var defaultQuery = ActivityQuery()
}

// Query to provide dynamic entities
struct ActivityQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [ActivityEntity] {
        let activities = await PersistenceManager.shared.activityActor.getAllAvaibleActivitys()
        return activities
            .filter { identifiers.contains($0.id!) }
            .map { ActivityEntity(id: $0.id!, name: $0.name!) }
    }
    
    func suggestedEntities() async throws -> [ActivityEntity] {
        let activities = await PersistenceManager.shared.activityActor.getAllAvaibleActivitys()
        return activities.map { ActivityEntity(id: $0.id!, name: $0.name!) }
    }
    
    func defaultResult() async -> ActivityEntity? {
        let activities = await PersistenceManager.shared.activityActor.getAllAvaibleActivitys()
        guard let first = activities.first else { return nil }
        return ActivityEntity(id: first.id!, name: first.name!)
    }
}

