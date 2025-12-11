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
            TimeLineView(selectedDate: Date.now).navigationTitle("My Day")
            
       
        }
    }
}

#Preview {
    HomeView()
}
