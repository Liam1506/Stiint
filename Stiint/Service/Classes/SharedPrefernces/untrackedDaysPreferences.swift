//
//  RetrievLastLogId.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation

public class UntrackedDaysPrefernces {
    private static let activityLogIdKey = "untrackedDays"
    
    /// Save activity log ID to UserDefaults
    public static func saveWeekdays(id: UUID) {
        print("Save UUID \(id)")
        UserDefaults.standard.set(id.uuidString, forKey: activityLogIdKey)
    }
    
    /// Retrieve activity log ID from UserDefaults
    public static func getActivityLogId() -> UUID? {
        guard let uuidString = UserDefaults.standard.string(forKey: activityLogIdKey) else {
            return nil
        }
        
        print("Get UUID \(uuidString)")
        return UUID(uuidString: uuidString)
    }
    
    /// Remove activity log ID from UserDefaults
    public static func removeActivityLogId() {
        print("Reomve UUID")
        UserDefaults.standard.removeObject(forKey: activityLogIdKey)
    }
    
    /// Check if activity log ID exists
    static func hasActivityLogId() -> Bool {
        return UserDefaults.standard.string(forKey: activityLogIdKey) != nil
    }
}
