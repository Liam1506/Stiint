//
//  CreateLog.swift
//  Stiint
//
//  Created by Liam Wittig on 13.01.26.
//

import SwiftUI
import SwiftData

struct CreateLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    
    @State private var defaultDate: Date
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var maxEndtime: Date
    
    
    @State private var activity: ActivityItem?
    
    
    
    @Query private var activities: [ActivityItem]
    
    
   
    
    init(defaultDate: Date){
        
        let calendar = Calendar.current
        
        self.defaultDate = defaultDate
        let endOfDate = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: defaultDate)
        )!
        
        
        
        if endOfDate < Date.now{
            maxEndtime = endOfDate
            endTime = endOfDate.addingTimeInterval(-3600 * 10)
            startTime = endOfDate.addingTimeInterval(-3600 * 11)
            return
        }
        

        if let time = DtoManager.shared.activityDTO?.startTime {
            
            if(time > calendar.startOfDay(for: Date.now)){
                self.defaultDate = time
            }
            maxEndtime = time
            endTime = time
            startTime = time.addingTimeInterval(-3600)
            return
            
        }
        maxEndtime = Date.now
        endTime = Date.now
        startTime = Date.now.addingTimeInterval(-3600)
        
    }
    
    func calcBounds(){

        let calendar = Calendar.current
        
        let endOfDate = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: defaultDate)
        )!
        
        
        
        if endOfDate < Date.now{
            
            maxEndtime = endOfDate
            endTime = endOfDate.addingTimeInterval(-3600 * 10)
            startTime = endOfDate.addingTimeInterval(-3600 * 11)
            return
        }
        

        if let time = DtoManager.shared.activityDTO?.startTime {
            if(time > calendar.startOfDay(for: Date.now)){
                defaultDate = time
            }
            maxEndtime = time
    
            endTime = time
            startTime = time.addingTimeInterval(-3600)
            
            
        }else{
            maxEndtime = Date.now
            
            endTime = Date.now
            startTime = Date.now.addingTimeInterval(-3600)
        }

    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Activity") {
                    Picker("Activity", selection: $activity) {
                        ForEach(activities) { activity in
                            Text(activity.name ?? "Unnamed")
                                .tag(activity as ActivityItem?)
                        }
                    }
                }
                Section("Time"){
                    
                    DatePicker(
                        "Date",
                        selection: $defaultDate,
                        in: ...maxEndtime,
                        displayedComponents: .date
                    ) .onChange(of: defaultDate) { old, newValue in
                        calcBounds()
                    }
                    DatePicker(
                        "Start Time",
                        selection: $startTime,
                        in: ...endTime,
                        displayedComponents: .hourAndMinute
                    )
                    
                    DatePicker(
                        "End Time",
                        selection: $endTime,
                        in: startTime...maxEndtime,
                        displayedComponents: .hourAndMinute
                    )
                    
                }
                Section("Duration") {
                    let duration = Duration.seconds(
                        endTime.timeIntervalSince(startTime)
                    )
                    Text(
                        duration,
                        format: .units(allowed: [.hours, .minutes])
                    )
                }
            }.onAppear(){
                activity = activities.first
            }        .navigationTitle("Create Log")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        
                        Button("Create") {
                            
                            guard endTime > startTime else {
                                return
                            }
                            
                            guard activity != nil else {
                                return
                            }
                            
                            Task{
                                if let activityId = activity!.id {
                                    
                                    Task{
                                        
                                        do {
                                            
                                            let startCurrentActivity = DtoManager.shared.activityDTO?.startTime
                                            try await PersistenceManager.shared.activityLogActor
                                                .clearTimeFrame(
                                                    startDate: startTime,
                                                    endDate: endTime,
                                                    logId: UUID(),
                                                    currentActivityStartDate: startCurrentActivity
                                                    
                                                )
                                            
                                            await PersistenceManager.shared.activityLogActor
                                                .insertActivityLog(
                                                    activityId: activityId,
                                                    startTime: startTime,
                                                    endTime: endTime
                                                )
                                            
                                            
                                            try modelContext.save()
                                            dismiss()
                                        } catch{
                                            
                                            print("Error saving: \(error)")
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    CreateLogView(defaultDate: Date.now)
}
