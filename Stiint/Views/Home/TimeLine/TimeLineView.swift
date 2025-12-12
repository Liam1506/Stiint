//
//  TimeLineView.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import SwiftUI
import SwiftData
internal import Combine

struct TimeLineView: View {
    @Query(sort: \ActivityLog.startTime) private var allLogs: [ActivityLog]
    let selectedDate: Date
    let calendar = Calendar.current
    let hours: [Int] = Array(0...23)
    
    
    let totalHours: Int = 24
    
    let currentHour: Int = Calendar.current.component(.hour, from: Date())
    @State private var currentTimeValue: Double = 0.0

    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    @State private var currentZoom = 0.0
       @State private var totalZoom = 1000.0
       
       // Add minimum and maximum zoom constraints
       private let minZoom: Double = 800.0
       private let maxZoom: Double = 5000.0

    
    
    let lineHeight: CGFloat = 2


    var logs: [ActivityLog] {
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return allLogs.filter { log in
            guard let startTime = log.startTime else { return false }
            return startTime >= startOfDay && startTime < endOfDay
        }
    }
    
    func updateTime(){
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        let minute = Calendar.current.component(.minute, from: now)
        let second = Calendar.current.component(.second, from: now)
        currentTimeValue = Double(hour) + Double(minute)/60 + Double(second)/3600
    }
    
    func calculateGeometryOfHouer(hour: Double, geometry: GeometryProxy)-> CGFloat{
        return geometry.size.height / 24 * CGFloat(hour) + (geometry.size.height/24)/2
    }
    

    
    func getGeometry(date: Date?, geometry: GeometryProxy)-> CGFloat{
        if date == nil { let timeVal = TimeHandler().getTimeValueForDate(date: Date.now, selectedDate: selectedDate);
            return calculateGeometryOfHouer(hour: timeVal, geometry: geometry)}
        
        
            let startOfDay = calendar.startOfDay(for: selectedDate)
        
        if date! <= startOfDay {
            return calculateGeometryOfHouer(hour: 0, geometry: geometry)
        }
        
        
        
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        

        if date! >= endOfDay {
            return calculateGeometryOfHouer(hour: Double(totalHours), geometry: geometry)
        }
    
    
        let timeVal = TimeHandler().getTimeValueForDate(date: date!, selectedDate: selectedDate)
        return calculateGeometryOfHouer(hour: timeVal, geometry: geometry)
    }

    var body: some View {
        
        ScrollViewReader { proxy in
            ScrollView{
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        // Background timeline
                        VStack(spacing: 0) {
                            ForEach(hours, id: \.self) { hour in
                                TimeLineSegmentView(hour: hour, height: geometry.size.height / 24).id(hour)
                            }
                        }
                        ForEach(logs) { log in
                            TimeLineActivitySegmentView(start: getGeometry(date: log.startTime, geometry: geometry), end: getGeometry(date: log.endTime, geometry: geometry), log: log)
                        }
                        
                        // Moving red line
                        Rectangle()
                            .padding([.leading], 0)
                            .frame(height: lineHeight)
                            .foregroundColor(.accentColor)
                            .opacity(0.4)
                            .frame(maxWidth: .infinity)
                            .offset(y: CGFloat(currentTimeValue) * (geometry.size.height/24) + (geometry.size.height/24)/2 - CGFloat(lineHeight/2))
                    }
                }
                .frame(height: currentZoom + totalZoom)
                .padding(.horizontal, 20)
            } .onAppear {
                updateTime()
                // Scroll to the current hour
                //let currentHour = Calendar.current.component(.hour, from: Date())
                withAnimation {
                    proxy.scrollTo(currentHour, anchor: .center)
                }
            }.onReceive(timer) { _ in
                print("Update")
                updateTime()
         
            }
        }
       
    }
}

#Preview {
    TimeLineView(selectedDate: Date.now)
}
