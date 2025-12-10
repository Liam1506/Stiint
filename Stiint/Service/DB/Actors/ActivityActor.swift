//
//  ActivityActor.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//


import Foundation
import SwiftData


@ModelActor
public actor ActivityActor {
    public func addActivity(name: String) {
        if(getActivityByName(from: name) != nil) {
            return
        }
        let activity = Activity(name: name)
        modelContext.insert(activity)
        try? modelContext.save()
    }
    
    public func editActivityById(activityId: UUID, newActivity: Activity) {
        let fetchDescriptor = FetchDescriptor<Activity>(
               predicate: #Predicate { $0.id == activityId }
           )
        let activity = try? modelContext.fetch(fetchDescriptor).first
        
        activity?.name = newActivity.name
        
        try? modelContext.save()
    }
    
    public func getAllAvaibleActivitys() -> [Activity]{
        let fetchDescriptor = FetchDescriptor<Activity>()
        let activitys = try? modelContext.fetch(fetchDescriptor)
        
        return activitys ?? []
    }
    
    public func getActivityByName(from name: String) -> Activity? {
        let fetchDescriptor = FetchDescriptor<Activity>(
               predicate: #Predicate { $0.name == name }
           )
        let activity = try? modelContext.fetch(fetchDescriptor)
        
        return activity?.first
    }
    public func getActivityById(from activityId: UUID) -> Activity?{
        let fetchDescriptor = FetchDescriptor<Activity>(
               predicate: #Predicate { $0.id == activityId }
           )
        let activity = try? modelContext.fetch(fetchDescriptor)
        
        return activity?.first
    }

    public func delete(_ activity: Activity) {
        modelContext.delete(activity)
        try? modelContext.save()
    }
}
