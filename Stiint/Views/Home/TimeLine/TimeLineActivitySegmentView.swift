//
//  TimeLineActivitySegmentView.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import SwiftUI

struct TimeLineActivitySegmentView: View {
    
    let start: CGFloat;
    let end: CGFloat;
    let log: ActivityLog
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Rectangle()
                .frame(height: end-start)
                .foregroundColor(log.activity!.color).cornerRadius(10)
            if(end-start > 50){
                
                Text(log.activity!.name ?? "no name")
                    .font(.headline)
                    .padding(10)
            }
            
        }
        .onTapGesture {
            print("Tap on Activity \(log.activity?.name)")
        }
        .padding(.leading, 40)
            .offset(y: start)
    }
}

#Preview {
    TimeLineActivitySegmentView(start: 0, end: 51, log: ActivityLog(startTime:  Date.now, activity: Activity(id: UUID(), createdDate: Date.now, name: "test", color: .pink)))
}
