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
        self.defaultDate = defaultDate

        if let time = RunningManager.shared.activityDTO?.startTime {
            self.maxEndtime = time
            self.endTime = time
            self.startTime = time.addingTimeInterval(-3600)
        }else{
            self.maxEndtime = Date.now
            self.endTime = Date.now
            self.startTime = Date.now.addingTimeInterval(-3600)
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
                        in: ...Date.now,
                        displayedComponents: .date
                    )
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
                                            
                                            let startCurrentActivity = RunningManager.shared.activityDTO?.startTime
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
