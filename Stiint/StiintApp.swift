//
//  StiintApp.swift
//  Stiint
//
//  Created by Liam Wittig on 10.12.25.
//

import SwiftData
import SwiftUI

@main
struct StiintApp: App {
    var body: some Scene {
        WindowGroup {
            if SetupManager.shared.isSetupComplete {
                ContentView().onAppear(){
                    
                         _ = RunningManager.shared
                    
                }
            } else {
                SetupManagerView()
            }
        }
        
        .modelContainer(PersistenceManager.shared.modelContainer)
    }
}
