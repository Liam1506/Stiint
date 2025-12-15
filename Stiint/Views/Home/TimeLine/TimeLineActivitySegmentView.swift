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
    
    
    @State private var isShowingLogSheet = false
    
    var body: some View {
        
        if(end-start > 0){
            
            
            ZStack(alignment: .topLeading){
                Rectangle()
                    .frame(height: end-start)
                    .foregroundColor(log.activity?.color ?? .blue).cornerRadius(10)
                if(end-start > 50){
                    HStack{
                        
                        Image(systemName: log.activity?.sfSymbolName ?? "questionmark.circle.dashed")
                        
                        Text(log.activity?.name ?? "no name")
                        
                    }     .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                }
                
            }
            .onTapGesture {
                isShowingLogSheet.toggle()
            }.sheet(isPresented: $isShowingLogSheet) {
                LogDetailView(log: log)
            }
            .padding(.leading, 40)
            .offset(y: start)
        }
    }
}

#Preview {
    TimeLineActivitySegmentView(start: 0, end: 51, log: ActivityLog(startTime:  Date.now, activity: Activity(id: UUID(), createdDate: Date.now, name: "test", color: .pink)))
}
