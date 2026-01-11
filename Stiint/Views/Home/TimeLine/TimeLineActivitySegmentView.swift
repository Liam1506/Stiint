//
//  TimeLineActivitySegmentView.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//

import SwiftUI

struct TimeLineActivitySegmentView: View {
    let start: CGFloat
    let end: CGFloat
    let log: ActivityLog

    let fmt = DateComponentsFormatter()

    let timeDistance: String

    init(start: CGFloat, end: CGFloat, log: ActivityLog, isShowingLogSheet: Bool = false) {
        self.start = start
        self.end = end
        self.log = log
        self.isShowingLogSheet = isShowingLogSheet

        fmt.unitsStyle = .abbreviated
        fmt.allowedUnits = [.hour, .minute]
        let secs = (log.endTime ?? Date.now).timeIntervalSince(log.startTime!)
        timeDistance = fmt.string(from: secs) ?? "Formating error"
    }

    @State private var isShowingLogSheet = false

    var body: some View {
        if end - start > 5 || log.endTime == nil {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .frame(height: end - start)
                    .foregroundColor(log.activity?.color ?? .blue).cornerRadius(10)
                    .shadow(color: (log.activity?.color ?? .blue).opacity(0.3), radius: 10, x: 0, y: 5)
                if end - start > 39 {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: log.activity?.sfSymbolName ?? "questionmark.circle.dashed")

                            Text(log.activity?.name ?? "no name")

                        }.font(.headline)
                            .foregroundColor(.white)

                        if end - start > 59 {
                            if log.endTime == nil {
                                Text(log.startTime!, style: .timer)
                                    .monospaced()
                                    .foregroundColor(.white)
                            } else {
                                Text(timeDistance)
                                    .foregroundColor(.white)
                            }
                        }
                    }.padding(10)
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
    TimeLineActivitySegmentView(start: 0, end: 60, log: ActivityLog(startTime: Date.now, activity: ActivityItem(id: UUID(), createdDate: Date.now, name: "test", color: .pink)))
}
