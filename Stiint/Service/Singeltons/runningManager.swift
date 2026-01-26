//
//  runningManager.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import ActivityKit
import Foundation
import Observation
import SwiftData
import SwiftUI

public actor RunningManager {
    private(set) var currentActivityLogId: UUID?
    
    private var setupTask: Task<Void, Never>?
    
    
    private var setupComplete = false;
    
    init(){
        Task {
            await setup()
        }
    }

    private func killDeadActvities() async{x
        try? await PersistenceManager.shared.activityLogActor
            .killDeadActvities(knwonRunningid: currentActivityLogId)
        
    }
    
    private func ensureReady() async {
        await setup()
    }
    
    private func setup() async {
            // If setup is already running, await its completion
            if let existing = setupTask {
                await existing.value
                return
            }
            
            // If already complete, return immediately
            guard !setupComplete else { return }
            
            // Create and store the setup task
            let task = Task {
                currentActivityLogId = await ActivityLogPreferences.getActivityLogId()
                
                await killDeadActvities()
                
                if let id = currentActivityLogId {
                    await DtoManager.shared
                        .setActivityDTO(
                            await PersistenceManager.shared.activityLogActor
                                .getActivtyLogDTO(activityLogId: id)
                        )

                    guard await DtoManager.shared.activityDTO != nil else {
                        currentActivityLogId = nil
                        await ActivityLogPreferences.removeActivityLogId()
                        setupComplete = true
                        return
                    }
                    
                    await LiveActivityManager.shared
                        .startLiveActivity(dto: await DtoManager.shared.activityDTO!)
                        
                } else {
                    print("No running activity found")
                }
                
                setupComplete = true
            }
            
            setupTask = task
            await task.value
            setupTask = nil // Clear the task once complete
        }


    public func stopSpecificAndStartPreviousActivity(activityId: UUID) async {
        
        await ensureReady()
        
        guard currentActivityLogId != nil else { return }

        guard await DtoManager.shared.activityDTO?.id == activityId else {
            return
        }

        if let previLogId = await PersistenceManager.shared.activityLogActor.getPreviousActivtyLogID(
            activityLogId: currentActivityLogId!
        ) {
            if let previId = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(
                activityLogId: previLogId
            ) {
                await startActivity(activityId: previId.id)
            }
        } else {
            await stopActivity()
        }
    }

    // If activiyt is smaller the 5 minutes away, it should be returend
    // Currently not working, only by soft reset
    /* private func checkResume(activityId: UUID) async-> Bool{

     guard activityDTO == nil else { return false }

     if let previLogId = await PersistenceManager.shared.activityLogActor.getPreviousActivtyLogID(activityLogId: currentActivityLogId!){
     let oldActvityEndTime = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(activityLogId: previLogId)?.endTime

     if oldActvityEndTime == nil { return false}

     let fiveMinutes: TimeInterval = 5 * 60
     let now = Date()

     return now.timeIntervalSince(oldActvityEndTime!) <= fiveMinutes
     && now.timeIntervalSince(oldActvityEndTime!) >= 0
     }
     return false
     } */

    public func startActivity(activityId: UUID) async {
        await ensureReady()
        print("START \(activityId)")
        
        let dto = await DtoManager.shared.activityDTO
        guard dto?.id != activityId else {
            return
        }

        var prevId: UUID? = nil

        if dto != nil {
            prevId = currentActivityLogId
            await stopActivity()
        }

        currentActivityLogId = await PersistenceManager.shared.activityLogActor
            .startActivity(activityId: activityId, previousAcvitiyLogId: prevId)
        guard currentActivityLogId != nil else { return }

        let activityDTO = await PersistenceManager.shared.activityLogActor.getActivtyLogDTO(
            activityLogId: currentActivityLogId!
        )
        
        await DtoManager.shared.setActivityDTO(activityDTO)

        await ActivityLogPreferences
            .saveActivityLogId(id: currentActivityLogId!)


        await LiveActivityManager.shared.startLiveActivity(dto: activityDTO!)
        
    }

    public func stopSpecificActivity(activityId: UUID) async {
        await ensureReady()
        guard  await DtoManager.shared.activityDTO?.id == activityId else {
            return
        }

        await stopActivity()
    }

    public func stopActivity() async {
        await ensureReady()
        if currentActivityLogId == nil { return }

        await PersistenceManager.shared.activityLogActor
            .stopActivity(activityLogId: currentActivityLogId!)

        await ActivityLogPreferences.removeActivityLogId()

        currentActivityLogId = nil
        await DtoManager.shared.clear()

        await LiveActivityManager.shared.stopLiveActivity()
    }
    
}

public extension RunningManager {
    static let shared = RunningManager()
}
