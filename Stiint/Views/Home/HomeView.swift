import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var dayOffset: Int = 0
    @State private var date: Date = .now
    
    enum ActiveSheet: Identifiable {
        case createLog, selectDate
        var id: Int { hashValue }
    }
    
    let dayRange: Int = -2000
    
    @State private var activeSheet: ActiveSheet?
    
    @Query(sort: \ActivityLog.startTime) var logs: [ActivityLog]
    
    private func dateFor(offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: offset, to: .now) ?? .now
    }
    
    private func offsetFor(date: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let startOfDate = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfDate).day ?? 0
    }
    
    private func formattedDate(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(dayRange...0, id: \.self) { offset in
                        TimeLineView(selectedDate: dateFor(offset: offset))
                            .containerRelativeFrame(.horizontal)
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
            }.scrollPosition(id: .init(get: { dayOffset }, set: { dayOffset = $0 ?? 0 }))
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea(edges: [.top, .bottom])
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { activeSheet = .createLog } label: {
                        Image(systemName: "plus")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Button {
                        date = dateFor(offset: dayOffset)
                        activeSheet = .selectDate } label: {
                        Text(formattedDate(for: dateFor(offset: dayOffset)))
                    }}
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .sensoryFeedback(.selection, trigger: dayOffset)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .createLog:
                CreateLogView(defaultDate: dateFor(offset: dayOffset))
            case .selectDate:
                DaySelectionSheet(date: $date, dayRange: dayRange)
                    .presentationDetents([.medium])
                    .onChange(of: date) { _, newDate in
                        // When user picks a date, we jump the scroll position
                        
                        withAnimation(.spring()) {
                            dayOffset = offsetFor(date: newDate)
                        }
                    }
            }
        }
    }
}
