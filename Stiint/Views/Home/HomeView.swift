//
//  HomeView.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var selectedDate: Date = .now
    @State private var createNewLog: Bool = false
    
    @Query(sort: \ActivityLog.startTime) var logs: [ActivityLog]

    var body: some View {
        NavigationView {
            TimeLineView(selectedDate: selectedDate)
            
                .navigationTitle(formattedDate)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            createNewLog.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                        }) {
                            Image(systemName: "chevron.left")
                        }
                    }
                    
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                        }) {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(Calendar.current.isDateInToday(selectedDate))
                    }
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            selectedDate = Date.now
                        }) {
                            Image(systemName: "calendar")
                        }
                        .disabled(Calendar.current.isDateInToday(selectedDate))
                    }
                    
                }.sheet(isPresented: $createNewLog){
                    CreateLogView(defaultDate: selectedDate)
                    
                }
        }
    }

    private var formattedDate: String {
        if Calendar.current.isDateInToday(selectedDate) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(selectedDate) {
            return "Yesterday"
        } else if Calendar.current.isDateInTomorrow(selectedDate) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: selectedDate)
        }
    }
}

#Preview {
    HomeView()
}
