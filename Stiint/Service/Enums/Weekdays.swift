//
//  Weekdays.swift
//  Stiint
//
//  Created by Wittig, Liam on 16.12.25.
//

import Foundation


public enum Weekday: Int, CaseIterable, Identifiable, Hashable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    public var id: Int { rawValue }
    
    static var today: Weekday {
        let weekday = Calendar.current.component(.weekday, from: Date())
        let mondayBasedIndex = (weekday + 5) % 7
        return Weekday(rawValue: mondayBasedIndex)!
    }
    
    var title: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
    var shortTitle: String {
           switch self {
           case .monday: return "Mon"
           case .tuesday: return "Tue"
           case .wednesday: return "Wed"
           case .thursday: return "Thu"
           case .friday: return "Fri"
           case .saturday: return "Sat"
           case .sunday: return "Sun"
           }
       }
}


