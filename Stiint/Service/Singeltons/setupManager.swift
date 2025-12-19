//
//  RunningManager.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//



import Foundation
import SwiftData
import SwiftUI
import Observation
import ActivityKit

@Observable
public final class SetupManager {
    
    private(set) var currentActivityLogId: UUID?
    
    private(set) var isSetupComplete: Bool
    private(set) var activityDTO: ActivityDTO?
    
    
    init(){
        self.isSetupComplete = SetupPreferences.isSetupCompleted()
    }
  
    public func completeSetup(){
        
        self.isSetupComplete = true
        SetupPreferences.setSetupCompleted(status: true)
    }
    public func resetSetup(){
        self.isSetupComplete = false
        
        SetupPreferences.setSetupCompleted(status: false)
    }
}

public extension SetupManager {
    static let shared = SetupManager()
}
