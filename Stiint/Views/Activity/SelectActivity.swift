//
//  SelectActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI
import SwiftData

struct SelectActivity: View {
    @State private var isShowingSheet = false
    @Query private var activities: [Activity]
    
    var body: some View {
        
        List(activities) { activity in
            Text(activity.name!).onTapGesture {
                RunningManager.shared.startActivity(activityId: activity.id!)
            }
        }.navigationTitle("Start Activity")
            .sheet(isPresented: $isShowingSheet) {
                CreateActivity()
            }
            .navigationTitle("Start Activity")
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingSheet.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    SelectActivity()
}
