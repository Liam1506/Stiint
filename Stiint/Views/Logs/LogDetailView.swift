//
//  logDetailView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import SwiftUI
import SwiftData

struct LogDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var log: ActivityLog
    
    @Query private var activities: [ActivityItem]
    
    @State private var showDeleteConfirmation = false
 
    
    private func maxStartTime() -> Date {
        return Date.now
    }
    
    private func maxEndTime(for startTime: Date) -> Date {
        // If start time is today, max is now
        // If start time is in the past, max is end of that day or now, whichever is earlier
        if Calendar.current.isDateInToday(startTime) {
            return Date.now
        } else {
            let endOfStartDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: startTime) ?? startTime
            return min(endOfStartDay, Date.now)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                Section("Activity") {
                    Picker("Activity", selection: $log.activity) {
                        Text("None").tag(nil as ActivityItem?)
                        ForEach(activities) { activity in
                            Text(activity.name ?? "Unnamed").tag(activity as ActivityItem?)
                        }
                    }
                }
                /*
                Section("Time") {
              
                     DatePicker("Start Time",
                     selection: Binding(
                     get: { log.startTime ?? Date.now },
                     set: { newValue in
                     log.startTime = newValue
                     
                     
                     // Clear end time if it would create negative duration
                     if let endTime = log.endTime, endTime <= newValue {
                     log.endTime = nil
                     }
                     }
                     ),
                     in: ...Date.now,
                     displayedComponents: [.hourAndMinute])
                     
                     
                     
                     
                     if let endTime = log.endTime, let startTime = log.startTime {
                     DatePicker("End Time",
                     selection: Binding(
                     get: { endTime },
                     set: { newValue in
                     
                     if(newValue > startTime ){
                     log.endTime = newValue
                     }
                     }
                     ),
                     in: startTime...maxEndTime(for: startTime),
                     displayedComponents: [.hourAndMinute])
                     }
                     }
                     */
                    if let startTime = log.startTime, let endTime = log.endTime {
                        Section("Duration") {
                            let duration = endTime.timeIntervalSince(startTime)
                            let hours = Int(duration) / 3600
                            let minutes = Int(duration) % 3600 / 60
                            
                            if hours > 0 {
                                Text("\(hours)h \(minutes)m")
                            } else {
                                Text("\(minutes)m")
                            }
                        }
                    }
                
                Section {
                    Button(role: .destructive, action: {
                        showDeleteConfirmation = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Delete Log")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
           
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
            .alert("Delete Log", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    modelContext.delete(log)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this log? This action cannot be undone.")
            }
        }
    }
}
