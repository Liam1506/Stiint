//
//  TimeLineCurrentTimeView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import SwiftUI
internal import Combine

struct TimeLineCurrentTimeView: View {
    let lineHeight: CGFloat = 2
    
    let currentTimeValue: Double
    let geometry: GeometryProxy
    let frameHieght: CGFloat = 40
    
    
    var body: some View {
        
        HStack(spacing: 0){
            Text(Date.now, format: .dateTime.hour().minute())
                .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                .background(.red)
                .foregroundStyle(.white)
                .font(.footnote)
                .cornerRadius(10)
            
            // remove padding between line and text
            
            Rectangle()
                .frame(height: lineHeight)
                .foregroundColor(.red)
            
            
            
            
        }.frame(height: frameHieght)
            .padding(.leading, 15)
        .offset(y: CGFloat(currentTimeValue) * (geometry.size.height/24) + (geometry.size.height/24)/2 - CGFloat(frameHieght/2))
        
    }
}


