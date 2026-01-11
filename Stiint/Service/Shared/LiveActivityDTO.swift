//
//  LiveActivityDTO.swift
//  Stiint
//
//  Created by Wittig, Liam on 17.12.25.
//

import ActivityKit
import Foundation
import SwiftUI

struct LiveActivityDTO: ActivityAttributes, Hashable, Decodable {
    typealias Status = ContentState

    let id: UUID
    let name: String
    let startTime: Date
    let icon: String
    let color: String

    struct ContentState: Codable, Hashable {
        var isActive: Bool
    }
}
