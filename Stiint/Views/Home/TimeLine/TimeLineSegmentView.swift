//
//  TimeLineSegmentView.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import Foundation
import SwiftUI

struct TimeLineSegmentView: View {
    let hour: Int
    let height: CGFloat
    var body: some View {
        HStack(alignment: .center) {
            Text(TimeHandler().nativeHourString(hour: hour)).foregroundStyle(.secondary).font(.footnote)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.secondary)
                .offset(y: -1)
        }
        .frame(height: height)
    }
}

#Preview {
    TimeLineSegmentView(hour: 3, height: 20)
}
