//
//  ActivityIntentLoader.swift
//  Stiint
//
//  Created by Wittig, Liam on 20.12.25.
//

import Foundation
import AppIntents


// Dynamic Entity that loads from PersistenceManager
struct ActivityEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Activity"
    }
    
    var id: UUID
    var name: String
    var startDate: Date?
    
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

