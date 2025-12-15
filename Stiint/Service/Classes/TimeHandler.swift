//
//  nativeHourString.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import Foundation

class TimeHandler{
    
    
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
        let date = calendar.date(from: comps)!

        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short     // uses the country’s own style

        return formatter.string(from: date)
    }
    
    func getTimeValueForDate(date: Date, selectedDate: Date)-> Double{
        
            let hour = Calendar.current.component(.hour, from: date)
            let minute = Calendar.current.component(.minute, from: date)
            let second = Calendar.current.component(.second, from: date)
        
            let startOfDay = calendar.startOfDay(for: selectedDate)
        if(date < startOfDay){
            return 0
        }
        
        return Double(hour) + Double(minute)/60 + Double(second)/3600
    }
}
