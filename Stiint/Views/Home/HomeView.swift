import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var dayOffset: Int = 0

    enum ActiveSheet: Identifiable {
        case createLog
        case selectDate
        var id: Int { hashValue }
    }

    @State private var activeSheet: ActiveSheet?

    let dayRange: Int = -2000

    @Query(sort: \ActivityLog.startTime)
    var logs: [ActivityLog]

    private func dateFor(offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: offset, to: .now) ?? .now
    }

    private func offsetFor(date: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let startOfDate = calendar.startOfDay(for: date)

        return calendar
            .dateComponents(
                [.day],
                from: startOfToday,
                to: startOfDate
            ).day ?? 0
    }

    private func formattedDate(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        return date.formatted(.dateTime.month(.abbreviated).day().year())
    }

    private var selectedDate: Date {
        dateFor(offset: dayOffset)
    }

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(dayRange...0, id: \.self) { offset in
                        TimeLineDisplayer(
                            offset: offset,
                            currentOffset: dayOffset
                        )
                        .tag(offset)
                        .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.6)
                                .scaleEffect(phase.isIdentity ? 1 : 0.92)
                                .blur(radius: phase.isIdentity ? 0 : 2)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(
                id: .init(
                    get: { dayOffset },
                    set: { dayOffset = $0 ?? 0 }
                )
            )
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea(edges: [.top, .bottom])
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        activeSheet = .createLog
                    } label: {
                        Image(systemName: "plus")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title3)
                    }
                }

                ToolbarItem(placement: .navigation) {
                    Button {
                        activeSheet = .selectDate
                    } label: {
                        Text(formattedDate(for: selectedDate))
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .sensoryFeedback(.selection, trigger: dayOffset)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .createLog:
                CreateLogView(defaultDate: selectedDate)

            case .selectDate:
                DaySelectionSheet(
                    date: .init(
                        get: { selectedDate },
                        set: { dayOffset = offsetFor(date: $0) }
                    ),
                    dayRange: dayRange
                )
                .presentationDetents([.medium])
            }
        }
    }
}

struct TimeLineDisplayer: View {
    let offset: Int
    let currentOffset: Int

    private var date: Date {
        Calendar.current.date(byAdding: .day, value: offset, to: .now) ?? .now
    }

    var body: some View {
        ZStack {
            if abs(offset - currentOffset) <= 1 {
                TimeLineView(selectedDate: date)
            } else {
                Color.clear
            }
        }
        .containerRelativeFrame(.horizontal)
    }
}
