//
//  StiintApp.swift
//  Stiint
//
//  Created by Liam Wittig on 10.12.25.
//

import SwiftUI
import SwiftData

@main
struct StiintApp: App{
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(PersistenceManager.shared.modelContainer)
    }
}
