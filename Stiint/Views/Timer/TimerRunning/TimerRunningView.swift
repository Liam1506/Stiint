//
//  TimerRunningView.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI

struct TimerRunningView: View {
    /*
      Show the timer itself with teh actiovity.
     Singe button to end task -> Should change state other page should be shown
        */
    init(){
        //print(RunningManager.shared.currentActivityLogId!)
    }
    
    @State private var activityLog: ActivityLog?
    
    var body: some View {
        
        if(RunningManager.shared.activityDTO == nil){
            Text("Awaiting activityDTO")
        }
        
        else if(RunningManager.shared.currentActivityLogId == nil){
            Text("Awaiting currentActivityLogId")
        }else{
            
            NavigationView {
                VStack(spacing: 40){
                    
                    Text(RunningManager.shared.activityDTO!.startTime, style: .timer)
                        .font(.system(size: 80, weight: .light, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        Task {
                            await RunningManager.shared.stopActivity()
                        }
                    }) {
                        Text("Stop")
                            .font(.title2.bold())
                            .frame(maxWidth: 130, minHeight: 60)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                            .padding(.horizontal)
                            .glassEffect()
                    }
                    
                    .navigationTitle(RunningManager.shared.activityDTO!.name)
                    
                    
                }
            }
       
            
        }
    }
}

#Preview {
    TimerRunningView()
}
