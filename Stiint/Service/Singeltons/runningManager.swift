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
    
    
    private(set) var currentActivityId: UUID?
    
    private(set) var running: Bool
    private(set) var activityDTO: ActivityDTO?
    
    private(set) var previousActivityDTO: ActivityDTO?
    
    
    init(){
        print("INIT")
        running = false
        currentActivityId = nil
        
        activityDTO = nil
        setup();
    }
    
    private func setup() {
        currentActivityId = ActivityLogPreferences.getActivityLogId()
        if let id = currentActivityId{
            
            Task{
                activityDTO = await PersistenceManager.shared.activityLogActor.getStartTimeOfActivityLog(activityLogId: id)
            }
            
            running = true
        }
    }
    
    public func stopAndStartPreviousActivity(){
      
        Task{
            let prevId = previousActivityDTO?.id
            await stopActivity()
            if(prevId != nil){
                startActivity(activityId: prevId!)
            }
        }
    }
    
    
    public func startActivity(activityId: UUID){
        print("START \(activityId)")
        if(currentActivityId == activityId){
            return
        }
        if(activityDTO != nil){
            previousActivityDTO = activityDTO
        }
        
        Task{
            if(currentActivityId != nil ){
             await PersistenceManager.shared.activityLogActor.stopActivity(activityLogId: currentActivityId!)
            }
            currentActivityId = await PersistenceManager.shared.activityLogActor.startActivity(activityId: activityId)
            
            ActivityLogPreferences.saveActivityLogId(id: currentActivityId!)
            
            activityDTO = await PersistenceManager.shared.activityLogActor.getStartTimeOfActivityLog(activityLogId: currentActivityId!)
            
        }
        running = true
        
    }
    public func stopSpecificActivity(activityId: UUID){

        if(currentActivityId == activityId){
            Task{
              await stopActivity()
            }
        }
        
    }
   
    
    public func stopActivity() async {
        if(currentActivityId != nil ){
            await PersistenceManager.shared.activityLogActor.stopActivity(activityLogId: currentActivityId!)
            previousActivityDTO = activityDTO
        }
        ActivityLogPreferences.removeActivityLogId()
        
        currentActivityId = nil
        activityDTO = nil
        running = false
        
    }
        

    
    
}

public extension RunningManager {
    static let shared = RunningManager()
}
