//
//  LogHandler.swift
//  Stiint
//
//  Created by Liam Wittig on 26.01.26.
//

import Foundation
import os


public extension Logger {
    static let app = Logger(subsystem: Bundle.main.bundleIdentifier ?? "liwi.Stiint", category: "App")
    static let outside = Logger(subsystem: Bundle.main.bundleIdentifier ?? "liwi.Stiint", category: "Outside")
}
 
