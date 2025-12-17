//
//  LiveActivityDTO.swift
//  Stiint
//
//  Created by Wittig, Liam on 17.12.25.
//

import Foundation
import ActivityKit
import SwiftUI

struct LiveActivityDTO: ActivityAttributes, Hashable, Decodable {
    
    public typealias Status = ContentState

    let id: UUID
    let name: String
    let startTime: Date
    let icon: String
    let color: String

    public struct ContentState: Codable, Hashable {
        var isActive: Bool
    }
}
