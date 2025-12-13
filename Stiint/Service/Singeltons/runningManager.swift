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

@Observable
public final class RunningManager: Sendable {
    
    
    private(set) var currentActivityLogId: UUID?
    
    private(set) var running: Bool
    private(set) var activityDTO: ActivityDTO?
    private(set) var previousActivityDTO: ActivityDTO?
    
    
    init(){
        print("INIT")
        running = false
        currentActivityLogId = nil
        
        activityDTO = nil
        
        setup();
    }
    
    private func setup() {
        currentActivityLogId = ActivityLogPreferences.getActivityLogId()
        if let id = currentActivityLogId{
            
            Task{
                activityDTO = await PersistenceManager.shared.activityLogActor.getStartTimeOfActivityLog(activityLogId: id)
                
                running = true
            }
            
        }
    }
    
    public func stopAndStartPreviousActivity(){
      
        Task{
            let prevId = previousActivityDTO?.id
            let currentId = activityDTO?.id
            
            await stopActivity()
            if(prevId != nil && prevId != currentId){
                startActivity(activityId: prevId!)
            }
        }
    }
    
    
    public func startActivity(activityId: UUID){
        print("START \(activityId)")
        if(currentActivityLogId == activityId){
            return
        }
        if(activityDTO != nil){
            previousActivityDTO = activityDTO
        }
        
        Task{
            if(currentActivityLogId != nil ){
             await PersistenceManager.shared.activityLogActor.stopActivity(activityLogId: currentActivityLogId!)
            }
            currentActivityLogId = await PersistenceManager.shared.activityLogActor.startActivity(activityId: activityId)
            
            ActivityLogPreferences.saveActivityLogId(id: currentActivityLogId!)
            
            activityDTO = await PersistenceManager.shared.activityLogActor.getStartTimeOfActivityLog(activityLogId: currentActivityLogId!)
            
            running = true
        }
        
    }
    public func stopSpecificActivity(activityId: UUID){

        if(currentActivityLogId == activityId){
            Task{
              await stopActivity()
            }
        }
        
    }
   
    
    public func stopActivity() async {
        if(currentActivityLogId != nil ){
            await PersistenceManager.shared.activityLogActor.stopActivity(activityLogId: currentActivityLogId!)
            print("Setting previous dto")
        }
        ActivityLogPreferences.removeActivityLogId()
        
        currentActivityLogId = nil
        activityDTO = nil
        running = false
        
    }
        

    
    
}

public extension RunningManager {
    static let shared = RunningManager()
}
