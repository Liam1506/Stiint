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
public final class RunningManager {
    
    private(set) var currentActivityLogId: UUID?
    
    private(set) var running: Bool
    private(set) var activityDTO: ActivityDTO?
    
    
    init(){
        running = false
        setup();
    }
    
    private func setup() {
        currentActivityLogId = ActivityLogPreferences.getActivityLogId()
        
        if let id = currentActivityLogId{
            Task{
                activityDTO = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(activityLogId: id)

                guard activityDTO != nil else {
                    currentActivityLogId = nil
                    ActivityLogPreferences.removeActivityLogId()
                    return
                }
                
                running = true
                
                await LiveActivityManager.shared.startLiveActivity(dto: activityDTO!)
                
            }
        }else{
            print("No running activity found")
        }
    }
    
    public func stopSpecificAndStartPreviousActivity(activityId: UUID) async{
        guard currentActivityLogId != nil else { return }
        
        guard activityDTO?.id == activityId else { return }
        
            if let previLogId = await PersistenceManager.shared.activityLogActor.getPreviousActivtyLogID(activityLogId: currentActivityLogId!){
                if let previId = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(activityLogId: previLogId){
                    startActivity(activityId: previId.id)
                }
            }else{
                await stopActivity()
            
        }
    }
    
    
    
    //If activiyt is smaller the 5 minutes away, it should be returend
    // Currently not working, only by soft reset
    /*private func checkResume(activityId: UUID) async-> Bool{
        
        guard activityDTO == nil else { return false }
         
        
        let oldActvityEndTime = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(activityLogId: previousActivityLogId!)?.endTime
                
        if oldActvityEndTime == nil { return false}

        let fiveMinutes: TimeInterval = 5 * 60
        let now = Date()

        return now.timeIntervalSince(oldActvityEndTime!) <= fiveMinutes
            && now.timeIntervalSince(oldActvityEndTime!) >= 0
    }
    */
    
    public func startActivity(activityId: UUID){
        print("START \(activityId)")
        if(activityDTO?.id == activityId){
            print("Activity already running")
            return
        }
        
        
        Task{
            var prevId: UUID? = nil
            
            if(running){
                prevId = currentActivityLogId
                await stopActivity()
            }
            
            currentActivityLogId = await PersistenceManager.shared.activityLogActor.startActivity(activityId: activityId, previousAcvitiyLogId: prevId)
            guard currentActivityLogId != nil else { return }
            
            activityDTO = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(activityLogId: currentActivityLogId!)
            
            ActivityLogPreferences.saveActivityLogId(id: currentActivityLogId!)

            running = true
            
            
            
            await LiveActivityManager.shared.startLiveActivity(dto: activityDTO!)
            
            
        }
        
    }
    public func stopSpecificActivity(activityId: UUID) async{

        if(currentActivityLogId == activityId){
           
              await stopActivity()
            
        }
        
    }
   
    
    
    public func stopActivity() async {
        
        if currentActivityLogId == nil { return }
        
        await PersistenceManager.shared.activityLogActor.stopActivity(activityLogId: currentActivityLogId!)
        
        ActivityLogPreferences.removeActivityLogId()
        
        currentActivityLogId = nil
        activityDTO = nil
        running = false
        
        LiveActivityManager.shared.stopLiveActivity()
        
    }
    
    
}

public extension RunningManager {
    static let shared = RunningManager()
}
