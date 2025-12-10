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
        //print(RunningManager.shared.currentActivityId!)
    }
    
    @State private var activityLog: ActivityLog?
    
    var body: some View {
        if(RunningManager.shared.currentActivityId == nil || RunningManager.shared.activityDTO == nil){
            Text("Loading")
        }else{
            VStack{
                
                Text(RunningManager.shared.activityDTO!.startTime, style: .timer)
                    
                    Button("Stop"){
                        Task{
                            
                            await RunningManager.shared.stopActivity()
                        }
                    }
                
            }
       
            
        }
    }
}

#Preview {
    TimerRunningView()
}
