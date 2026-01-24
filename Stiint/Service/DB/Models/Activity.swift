//
//  Activity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
public final class ActivityItem {
    public var id: UUID?
    public var createdDate: Date?
    public var name: String?
    public var colorHex: String?
    public var sfSymbolName: String?
    public var deleted: Bool?
    public var weekdays: Set<Weekday>?
    public var storeLocation: Bool?

    public init(
        id: UUID? = nil,
        createdDate: Date? = nil,
        name: String? = nil,
        color: Color? = nil,
        sfSymbolName: String? = nil,
        deleted: Bool? = nil,
        weekdays: Set<Weekday> = [],
        storeLocation: Bool? = nil

    ) {
        self.id = id ?? UUID()
        self.createdDate = createdDate ?? Date.now
        self.name = name
        colorHex = color?.toHex()
        self.sfSymbolName = sfSymbolName
        self.deleted = deleted
        self.weekdays = weekdays
        self.storeLocation = storeLocation
    }

    public var color: Color {
        get { Color(hex: colorHex) }
        set { colorHex = newValue.toHex() }
    }
}
