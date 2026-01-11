//
//  setupManager.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import ActivityKit
import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
public final class SetupManager {
    private(set) var currentActivityLogId: UUID?

    private(set) var isSetupComplete: Bool
    private(set) var activityDTO: ActivityDTO?

    init() {
        isSetupComplete = SetupPreferences.isSetupCompleted()
    }

    public func completeSetup() {
        isSetupComplete = true
        SetupPreferences.setSetupCompleted(status: true)
    }

    public func resetSetup() {
        isSetupComplete = false

        SetupPreferences.setSetupCompleted(status: false)
    }
}

public extension SetupManager {
    static let shared = SetupManager()
}
