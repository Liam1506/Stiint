//
//  persistenceManager.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation
import SwiftData

public final class PersistenceManager: Sendable {
    public let modelContainer: ModelContainer
    public let activityActor: ActivityActor
    public let activityLogActor: ActivityLogActor

    init() {
        modelContainer = {
            let schema = Schema([
                ActivityItem.self,
                ActivityLog.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()

        activityActor = ActivityActor(modelContainer: modelContainer)
        activityLogActor = ActivityLogActor(modelContainer: modelContainer)
    }
}

public extension PersistenceManager {
    static let shared = PersistenceManager()
}
