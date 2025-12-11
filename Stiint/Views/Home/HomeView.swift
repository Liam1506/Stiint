//
//  HomeView.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    
    @Query(sort: \ActivityLog.startTime) var logs: [ActivityLog]
    var body: some View {
        NavigationView {
            VStack{
                
                
                List(logs) { log in
                    Text("\(log.activity?.name ?? "Unknown Activity") at \(log.endTime?.timeIntervalSince(log.startTime!) ?? 0)")
                }
            }.navigationTitle("My Day")
            
       
        }
    }
}

#Preview {
    HomeView()
}
