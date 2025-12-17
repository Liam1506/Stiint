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
    @State private var activityToEdit: ActivityItem?
    @State private var activityToDelete: ActivityItem?
    @State private var showDeleteConfirmation = false

    @Query(filter: #Predicate<ActivityItem> { activity in
        activity.deleted == nil || activity.deleted == false
    })
    private var activities: [ActivityItem]

    var body: some View {
        NavigationView {
            List(activities) { activity in
                HStack(spacing: 20) {
                    ZStack{
                        
                        Circle()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(activity.color)
                        
                            Image(systemName: activity.sfSymbolName ?? "xmark.circle")
                                .font(.system(size: 16, weight: .bold))
                  
                                
                    }
                    Text(activity.name!).fontWeight(.bold)
                    Spacer()
                }
                .contentShape(Rectangle())
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
                        activityToDelete = activity
                        showDeleteConfirmation = true
                    } label: {
                        Label("Remove", systemImage: "xmark.circle")
                    }
                }
            }
            .navigationTitle("Start Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingCreateSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingCreateSheet) {
                CreateActivityView(activityToEdit: nil)
            }
            .sheet(item: $activityToEdit) { activity in
                CreateActivityView(activityToEdit: activity)
            }.alert("Delete Activity", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let activity = activityToDelete {
                        Task {
                            await PersistenceManager.shared
                                .activityActor
                                .delete(from: activity.id!)
                        }
                        activityToDelete = nil
                    }
                }

                Button("Cancel", role: .cancel) {
                    activityToDelete = nil
                }
            } message: {
                Text("This action cannot be undone.")
            }

         
        }
    }
}


#Preview {
    SelectActivity()
}
