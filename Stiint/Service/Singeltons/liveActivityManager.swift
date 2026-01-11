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

    init() {}
    func setup() async {
        for activity in Activity<LiveActivityDTO>.activities {
            print("ID: \(activity.id)")
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        activity = nil
        print("Recoverd: \(Activity<LiveActivityDTO>.activities)")
    }

    public func startLiveActivity(dto: ActivityDTO) async {
        await setup()
        let liveDto = LiveActivityDTO(id: dto.id, name: dto.name, startTime: dto.startTime, icon: dto.icon, color: dto.color.toHex()!)
        let state = LiveActivityDTO.Status(isActive: true)
        do {
            activity = try Activity<LiveActivityDTO>.request(attributes: liveDto, content: .init(state: state, staleDate: nil), pushType: nil)
        } catch {
            print("FAILED to start activity: \(error.localizedDescription)")
        }
    }

    public func stopLiveActivity() {
        let state = LiveActivityDTO.Status(isActive: false)

        Task {
            await activity?.end(.init(state: state, staleDate: nil), dismissalPolicy: .immediate)
        }
    }
}

public extension LiveActivityManager {
    static let shared = LiveActivityManager()
}
