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
    private(set) var previousActivityLogId: UUID?
    
    private(set) var running: Bool
    private(set) var activityDTO: ActivityDTO?
    private(set) var previousActivityDTO: ActivityDTO?
    
    
    init(){
        running = false
        currentActivityLogId = nil
        activityDTO = nil
        
        setup();
    }
    
    private func setup() {
        currentActivityLogId = ActivityLogPreferences.getActivityLogId()
        if let id = currentActivityLogId{
            
            Task{
                activityDTO = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(activityLogId: id)
                print("Activity found \(activityDTO.debugDescription)")
                
                guard activityDTO != nil else {
                    currentActivityLogId = nil
                    ActivityLogPreferences.removeActivityLogId()
                    return
                }
                
                running = true
            }
            
        }else{
            print("ERROR: No ActivityLogId found")
        }
    }
    
    public func stopAndStartPreviousActivity(){
        
            let prevId = previousActivityDTO?.id
            let currentId = activityDTO?.id
            
        print("Prev id \(prevId)")
        
    print("currentId id \(currentId)")
      
        Task{
            await stopActivity()
            if(prevId != nil && prevId != currentId){
                startActivity(activityId: prevId!)
            }
        }
    }
    
    
    
    //If activiyt is smaller the 5 minutes away, it should be returend
    private func checkResume(activityId: UUID) async-> Bool{
        
        guard previousActivityLogId != nil else { return false }
        guard activityDTO == nil else { return false }
        guard previousActivityDTO?.id == activityId else { return false}
         
        
        let oldActvityEndTime = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(activityLogId: previousActivityLogId!)?.endTime
                
        if oldActvityEndTime == nil { return false}

        let fiveMinutes: TimeInterval = 5 * 60
        let now = Date()

        return now.timeIntervalSince(oldActvityEndTime!) <= fiveMinutes
            && now.timeIntervalSince(oldActvityEndTime!) >= 0
    }
    
    public func startActivity(activityId: UUID){
        print("START \(activityId)")
        if(activityDTO?.id == activityId){
            print("Activity already running")
            return
        }
        
        
        Task{
            
            let resumeActivity = await checkResume(activityId: activityId)
            
            if(currentActivityLogId != nil){
               await stopActivity()
            }
            
            print("Should resume \(resumeActivity)" )
            
            if (resumeActivity && previousActivityLogId != nil){
                currentActivityLogId = await PersistenceManager.shared.activityLogActor.resumeActivity(activityLogId: previousActivityLogId!)
                
            }else{
                
                print("STARTING NEW ACTIVITY \(activityId)")
                currentActivityLogId = await PersistenceManager.shared.activityLogActor.startActivity(activityId: activityId)
            }
            
            
            guard currentActivityLogId != nil else { return }
            
            ActivityLogPreferences.saveActivityLogId(id: currentActivityLogId!)

            activityDTO = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(activityLogId: currentActivityLogId!)
            
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
   
    
    public func stopActivity(newId: UUID? = nil) async {
        
        if currentActivityLogId == nil { return }
        
        await PersistenceManager.shared.activityLogActor.stopActivity(activityLogId: currentActivityLogId!)
        
        ActivityLogPreferences.removeActivityLogId()
        
        previousActivityLogId = currentActivityLogId
        
        print("Setting prev id to \(String(describing: previousActivityLogId))")
        
        print("Stopping activity and saving previous dto \(activityDTO.debugDescription)")
        if(activityDTO != nil && activityDTO?.id != newId){
            print("Overwriting old DTO")
            previousActivityDTO = activityDTO
        }
        
        currentActivityLogId = nil
        activityDTO = nil
        running = false
        
    }
        

    
    
}

public extension RunningManager {
    static let shared = RunningManager()
}
