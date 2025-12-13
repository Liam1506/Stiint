//
//  SelectActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI
import SwiftData

struct SelectActivity: View {
    @State private var isShowingCreateSheet = false
    @State private var activityToEdit: Activity?
    @Query private var activities: [Activity]
    
    var body: some View {
        
        NavigationView {
            List(activities) { activity in
                HStack {
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(activity.color)
                    Text(activity.name!)
                }
                .onTapGesture {
                    RunningManager.shared.startActivity(activityId: activity.id!)
                }
                .contextMenu {
                    Button {
                        activityToEdit = activity
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        // Delete action
                    } label: {
                        Label("Remove", systemImage: "xmark.circle")
                    }
                }
            }
            .navigationTitle("Start Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingCreateSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            // Sheet for creating new activity
            .sheet(isPresented: $isShowingCreateSheet) {
                CreateActivityView(activityToEdit: nil)
            }
            // Sheet for editing existing activity
            .sheet(item: $activityToEdit) { activity in
                CreateActivityView(activityToEdit: activity)
            }
        }
    }
}

#Preview {
    SelectActivity()
}
