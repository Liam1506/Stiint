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
public final class Activity {
    public var id: UUID?
    public var createdDate: Date?
    public var name: String?
    public var colorHex: String?   // Optional for iCloud compatibility
    public var sfSymbolName: String? // New property for SF Symbol

    public init(
        id: UUID? = nil,
        createdDate: Date? = nil,
        name: String? = nil,
        color: Color? = nil,
        sfSymbolName: String? = nil
    ) {
        self.id = id ?? UUID()
        self.createdDate = createdDate ?? Date.now
        self.name = name
        self.colorHex = color?.toHex()
        self.sfSymbolName = sfSymbolName
    }

    public var color: Color {
        get { Color(hex: colorHex) }
        set { colorHex = newValue.toHex() }
    }
}



extension Color {
    init(hex: String?) {
        guard let hex = hex else {
            self = .blue // default fallback color
            return
        }

        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        guard let rgbValue = UInt64(hexString, radix: 16) else {
            self = .blue
            return
        }

        let r = Double((rgbValue >> 16) & 0xFF) / 255
        let g = Double((rgbValue >> 8) & 0xFF) / 255
        let b = Double(rgbValue & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String? {
        #if os(macOS)
        typealias NativeColor = NSColor
        #else
        typealias NativeColor = UIColor
        #endif

        let uiColor = NativeColor(self)
        guard let components = uiColor.cgColor.components else { return nil }

        let r = components.count >= 3 ? components[0] : components[0]
        let g = components.count >= 3 ? components[1] : components[0]
        let b = components.count >= 3 ? components[2] : components[0]

        return String(format: "#%02lX%02lX%02lX",
                      lround(Double(r * 255)),
                      lround(Double(g * 255)),
                      lround(Double(b * 255)))
    }
}
