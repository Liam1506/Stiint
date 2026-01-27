//
//  stiintWidgetExtension.swift
//  stiintWidgetExtension
//
//  Created by Wittig, Liam on 17.12.25.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct stiintWidgetExtension: Widget {
    let kind: String = "stiintWidgetExtension"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityDTO.self) { context in
            // Lock screen / banner view
            HStack(spacing: 12) {
                Image(systemName: context.attributes.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .frame(width: 28, alignment: .center)
                    .foregroundColor(Color(hex: context.attributes.color))

                VStack(alignment: .leading, spacing: 0) {
                    Text(context.attributes.name)
                        .font(.headline)
                        .lineLimit(1)

                    Text(context.attributes.startTime, style: .timer)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .monospaced()
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded regions
                DynamicIslandExpandedRegion(.leading) {
                    // Image(systemName: context.attributes.icon).foregroundStyle(Color(hex:  context.attributes.color))
                    HStack{
                        VStack {
                            Spacer()
                            Image(systemName: context.attributes.icon)
                                .font(.system(size: 30))
                                .foregroundColor(
                                    Color(hex: context.attributes.color)
                                )
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        VStack{
                            Spacer()
                            Text(context.attributes.name)
                                .font(.headline)
                                .padding(.bottom, 14)
                                .lineLimit(1)
                                .frame(maxWidth: 200, alignment: .leading)
                                
                        }
                    }.frame(width: 200, height: 60)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    
                    VStack(alignment: .trailing){
                        Spacer()
                        Text(context.attributes.startTime, style: .timer)
                            .font(
                                .system(
                                    size: 100,
                                    weight: .light,
                                    design: .monospaced
                                )
                            )
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .frame(width: 100, height: 50, alignment: .center)
                        Spacer()
                    }.frame(height: 60)
                     
                    /*
                     Text(context.attributes.startTime, style: .timer)
                     .font(.system(size: 100, weight: .light, design: .monospaced))
                     .lineLimit(1)
                     .minimumScaleFactor(0.01)
                     .frame(width: 100, height: 50, alignment: .center)
                    
                     .frame(maxHeight: .infinity, alignment: .center)
                     */
                }
                /*DynamicIslandExpandedRegion(.center) {
                 Text(context.attributes.name)
                 .font(.headline)
                 .lineLimit(1)
                 .minimumScaleFactor(0.7)
                 // This frame aligns the text within the center block
                 // without forcing the whole Island to expand.
                 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                 .padding(.leading, 12)
                 .padding(.bottom, 4)
                 .background(.green)
                 }*/
                /*DynamicIslandExpandedRegion(.center,priority: 2) {
                 VStack (alignment: .leading){
                        
                        
                 HStack(alignment: .bottom) {
                 Text(context.attributes.name)
                 .font(.headline)
                 .lineLimit(1)                   // single line
                 .truncationMode(.tail)          // end with "..."
                 .frame( alignment: .leading)
                 .minimumScaleFactor(0.01)       // scales down if needed
                 .padding(.leading, 20)
                 Spacer()
                            
                 }
                 }
                 .background(.green)
                 }*/
            } compactLeading: {
                Image(systemName: context.attributes.icon)
                    .foregroundStyle(Color(hex: context.attributes.color))
                    .font(.system(size: 17))
            } compactTrailing: {
                EmptyView()
            } minimal: {
                Image(systemName: context.attributes.icon)
                    .foregroundStyle(Color(hex: context.attributes.color))
                    .font(.system(size: 17))
            }
        }
    }
}
