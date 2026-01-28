//
//  liveActivityManager.swift
//  Stiint
//
//  Created by Wittig, Liam on 17.12.25.
//

import ActivityKit
import Foundation
import SwiftData

public final class LiveActivityManager: Sendable {
    private var activity: Activity<LiveActivityDTO>?
    
    private func setup() async {
        
        let runningActvities = Activity<LiveActivityDTO>.activities
        
        print("Recoverd: \(runningActvities.count)")
        for activity in runningActvities {
            print("ID: \(activity.id)")
            if(activity.id == DtoManager.shared.activityDTO?.id.uuidString){
                continue
            }
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        activity = nil
    }

    public func startLiveActivity(dto: ActivityDTO) async {
        await setup()
        if let activity = activity {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        activity = nil
        let liveDto = LiveActivityDTO(
            id: dto.id,
            name: dto.name,
            startTime: dto.startTime,
            icon: dto.icon,
            color: dto.color.toHex()!
        )
        let state = LiveActivityDTO.Status(isActive: true)
        do {
            activity = try Activity<LiveActivityDTO>
                .request(
                    attributes: liveDto,
                    content: .init(state: state, staleDate: nil),
                    pushType: nil
                )
        } catch {
            print("FAILED to start activity: \(error.localizedDescription)")
        }
    }

    public func stopLiveActivity() async {
            guard let currentActivity = activity else {
                print("No active activity to stop")
                await setup()
                return
            }
            
            let state = LiveActivityDTO.Status(isActive: false)
            await currentActivity.end(
                .init(state: state, staleDate: nil),
                dismissalPolicy: .immediate
            )
            activity = nil
            await setup()
        }
}

public extension LiveActivityManager {
    static let shared = LiveActivityManager()
}
