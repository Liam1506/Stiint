//
//  TimeHandler.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import Foundation

class TimeHandler {
    let calendar = Calendar.current

    func secondsToLocalizedDuration(_ seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: TimeInterval(seconds)) ?? ""
    }

    func nativeHourString(hour: Int) -> String {
        var comps = DateComponents()
        comps.hour = hour
        comps.minute = 0

        let calendar = Calendar.current
        guard let date = calendar.date(from: comps) else { return "" }

        let formatter = DateFormatter()
        formatter.locale = Locale.current

        // Determine if the locale uses 12-hour format
        let formatString = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        let is12Hour = formatString.contains("a")

        if is12Hour {
            if hour == 12 {
                return "Noon" // 12 PM → Noon
            } else {
                formatter.dateFormat = "h a"
                return formatter.string(from: date)
            }
        } else {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
    }

    func getTimeValueForDate(date: Date, selectedDate: Date) -> Double {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let second = Calendar.current.component(.second, from: date)

        let startOfDay = calendar.startOfDay(for: selectedDate)
        if date < startOfDay {
            return 0
        }

        return Double(hour) + Double(minute) / 60 + Double(second) / 3600
    }
}
