//
//  setupPreferences.swift
//  Stiint
//
//  Created by Wittig, Liam on 19.12.25.
//

import Foundation

public class SetupPreferences {
    private static let activityLogIdKey = "setupCompletedKey"

    /// Save activity log ID to UserDefaults
    public static func setSetupCompleted(status: Bool) {
        UserDefaults.standard.set(status, forKey: activityLogIdKey)
    }

    public static func isSetupCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: activityLogIdKey)
    }
}
