//
//  HomeView.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State private var selectedDate: Date = Date.now
    @Query(sort: \ActivityLog.startTime) var logs: [ActivityLog]
    
    var body: some View {
        NavigationView {
            TimeLineView(selectedDate: selectedDate)
 
                .navigationTitle(formattedDate)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            selectedDate = Date.now
                        }) {
                            Image(systemName: "calendar")
                        }
                        .disabled(Calendar.current.isDateInToday(selectedDate))
                    
                }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                        }) {
                            Image(systemName: "chevron.left")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                        }) {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(Calendar.current.isDateInToday(selectedDate))
                    }
              
           
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
