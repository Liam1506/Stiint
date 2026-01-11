//
//  Untitled.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//
import ActivityKit
import Foundation
import SwiftUI

public struct ActivityDTO: Sendable {
    let id: UUID
    let name: String
    let startTime: Date
    let icon: String
    let color: Color
    let weekdays: Set<Weekday>
    var endTime: Date?
}
