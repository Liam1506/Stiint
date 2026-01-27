//
//  LogDetailView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import SwiftData
import SwiftUI
import MapKit

struct LogDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var log: ActivityLog

    @Query private var activities: [ActivityItem]

    @State private var showDeleteConfirmation = false

    
    @State private var startTime: Date
    @State private var endTime: Date
    
    
    @State private var maxEndtime: Date
    
    
    @State private var activity: ActivityItem
    
    init(log: ActivityLog) {
        self.log = log
        self.activity = log.activity!
        self.startTime = log.startTime!
        self.endTime = log.endTime ?? Date.now
        
        if let time = DtoManager.shared.activityDTO?.startTime {
            self.maxEndtime = time
        }else{
            self.maxEndtime = Date.now
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Activity") {
                    Picker("Activity", selection: $activity) {
                        ForEach(activities) { activity in
                            Text(activity.name ?? "Unnamed").tag(activity)
                        }
                    }
                }
                
                Section("Time"){
                    DatePicker(
                        "Start Time",
                        selection: $startTime,
                        in: ...endTime,
                        displayedComponents: .hourAndMinute
                    )
                    if(log.endTime != nil){
                        DatePicker(
                            "End Time",
                            selection: $endTime,
                            in: startTime...maxEndtime,
                            displayedComponents: .hourAndMinute
                        )
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
                Section("Duration") {
                    let duration = Duration.seconds(
                        endTime.timeIntervalSince(startTime)
                    )
                    Text(
                        duration,
                        format: .units(allowed: [.hours, .minutes])
                    )
                }
                
                
                if let startLatitude = log.startLatitude, let startLongitude = log.startLongitude, let endLatitude = log.endLatitude, let endLongitude = log.endLongitude {
                    
                   
                    Section("Location") {
                        Text(
                            LocationHandler()
                                .formatDistance(
                                    startLat: startLatitude,
                                    startLon: startLongitude,
                                    endLat: endLatitude,
                                    endLon: endLongitude
                                )
                        )
                    }
                    Map {
                                
                        Marker(
                            "Start location",
                            coordinate: CLLocationCoordinate2D(
                                latitude: startLatitude,
                                longitude: startLongitude
                            )
                        )
                        .tint(.orange)
                            
                            
                                
                        Marker(
                            "End location",
                            coordinate: CLLocationCoordinate2D(
                                latitude: endLatitude,
                                longitude: endLongitude
                            )
                        )
                        .tint(.blue)
                        MapPolyline(
                            coordinates: [
                                CLLocationCoordinate2D(
                                    latitude: startLatitude,
                                    longitude: startLongitude
                                ),
                                CLLocationCoordinate2D(latitude: endLatitude, longitude: endLongitude)
                            ]
                        )
                        .stroke(.blue, lineWidth: 3)
                    }
                    
                
                    .listRowInsets(EdgeInsets())
                        
                        
                    .frame(height: 400)
                    
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
                        
                        guard endTime > startTime else {
                            return
                        }
                        guard log.endTime != nil else {
                            return
                        }
                        Task{
                            
                            do {
                                let startCurrentActivity = DtoManager.shared.activityDTO?.startTime
                                try await PersistenceManager.shared.activityLogActor
                                    .clearTimeFrame(
                                        startDate: startTime,
                                        endDate: endTime,
                                        logId: log.id!,
                                        currentActivityStartDate: startCurrentActivity
                                    )
                                
                                log.endTime = endTime
                                log.startTime = startTime
                                log.activity = activity
                                
                                try modelContext.save()
                                dismiss()
                            } catch{
                                    
                                print("Error saving: \(error)")
                            }
                        }
                    }
                }
            }
            .alert("Delete Log", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    modelContext.delete(log)
                    try? modelContext.save()
                    dismiss()
                }
            } message: {
                Text(
                    "Are you sure you want to delete this log? This action cannot be undone."
                )
            }
        }
    }
}
