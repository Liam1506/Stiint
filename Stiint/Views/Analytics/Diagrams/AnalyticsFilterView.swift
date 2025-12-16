//
//  AnalyticsFilterView.swift
//  Pattrn
//
//  Created by Liam Wittig on 15.12.25.
//

import SwiftUI
import SwiftData

enum DateRangeFilter: String, CaseIterable, Identifiable {
    
    case yesterday = "Yesterday"
    case last7Days = "Last 7 Days"
    case lastMonth = "Last Month"
    case custom = "Custom Range"
    
    var id: String { rawValue }
}

public struct FilterData: Equatable {
    var startDate: Date
    var endDate: Date
    var showFreeTime: Bool
    var selectedActivityIds: [UUID]
}

struct AnalyticsFilterView: View {
    @Query(filter: #Predicate<Activity> { activity in
        activity.deleted == false || activity.deleted == nil
    }, sort: \Activity.createdDate) private var activities: [Activity]
    
    @State private var selectedDateRange: DateRangeFilter = .last7Days
    @State private var showFreeTime: Bool = true
    @State private var customStartDate: Date = Date().addingTimeInterval(-7 * 24 * 60 * 60)
    @State private var customEndDate: Date = Date()
    @State private var selectedActivities: Set<UUID> = []
    @State private var showFilterSheet: Bool = false
    
    let onFilterChange: (FilterData) -> Void
    
    var body: some View {
        Button(action: { showFilterSheet = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(getDateRangeDescription())
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    
                    HStack(spacing: 12) {
                        Label("\(selectedActivities.count) activities", systemImage: "chart.bar.fill")
                        
                        if showFreeTime {
                            Label("Free time", systemImage: "clock.fill")
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "slider.horizontal.3")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showFilterSheet) {
            FilterSheet(
                selectedDateRange: $selectedDateRange,
                showFreeTime: $showFreeTime,
                customStartDate: $customStartDate,
                customEndDate: $customEndDate,
                selectedActivities: $selectedActivities,
                activities: activities,
                onApply: applyFilter
            )
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            initializeSelectedActivities()
            applyFilter()
        }
    }
    
    // MARK: - Helper Functions
    private func initializeSelectedActivities() {
        selectedActivities = Set(activities.compactMap { $0.id })
    }
    
    private func applyFilter() {
        let (start, end) = getDateRange()
        let filterData = FilterData(
            startDate: start,
            endDate: end,
            showFreeTime: showFreeTime,
            selectedActivityIds: Array(selectedActivities)
        )
        onFilterChange(filterData)
    }
    
    private func getDateRange() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedDateRange {
        case .yesterday:
            let start = calendar.date(byAdding: .day, value: -1, to: now)!
            return (start, now)
        case .last7Days:
            let start = calendar.date(byAdding: .day, value: -7, to: now)!
            return (start, now)
       
        case .lastMonth:
            let startOfThisMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let startOfLastMonth = calendar.date(byAdding: .month, value: -1, to: startOfThisMonth)!
            let endOfLastMonth = calendar.date(byAdding: .day, value: -1, to: startOfThisMonth)!
            return (startOfLastMonth, endOfLastMonth)
        case .custom:
            return (customStartDate, customEndDate)
        }
    }
    
    private func getDateRangeDescription() -> String {
        let (start, end) = getDateRange()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

// MARK: - Filter Sheet
struct FilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedDateRange: DateRangeFilter
    @Binding var showFreeTime: Bool
    @Binding var customStartDate: Date
    @Binding var customEndDate: Date
    @Binding var selectedActivities: Set<UUID>
    let activities: [Activity]
    let onApply: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Date Range Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date Range")
                            .font(.headline)
                        
                        Picker("Date Range", selection: $selectedDateRange) {
                            ForEach(DateRangeFilter.allCases) { range in
                                Text(range.rawValue).tag(range)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        if selectedDateRange == .custom {
                            VStack(spacing: 12) {
                                DatePicker("Start Date", selection: $customStartDate, displayedComponents: .date)
                                DatePicker("End Date", selection: $customEndDate, displayedComponents: .date)
                            }
                            .padding(.top, 8)
                        }
                    }
                    
                    Divider()
                    
                    // Free Time Toggle
                    Toggle("Show Free Time", isOn: $showFreeTime)
                        .font(.headline)
                    
                    Divider()
                    
                    // Activity Selection
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Activities")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(selectedActivities.count == activities.count ? "Deselect All" : "Select All") {
                                if selectedActivities.count == activities.count {
                                    selectedActivities.removeAll()
                                } else {
                                    selectedActivities = Set(activities.compactMap { $0.id })
                                }
                            }
                            .font(.caption)
                        }
                        
                        if activities.isEmpty {
                            Text("No activities available")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 8)
                        } else {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                                ForEach(activities) { activity in
                                    if let activityId = activity.id {
                                        ActivityFilterChip(
                                            activity: activity,
                                            isSelected: selectedActivities.contains(activityId)
                                        ) {
                                            if selectedActivities.contains(activityId) {
                                                selectedActivities.remove(activityId)
                                            } else {
                                                selectedActivities.insert(activityId)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Filter Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Activity Filter Chip
struct ActivityFilterChip: View {
    let activity: Activity
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                if let iconName = activity.sfSymbolName {
                    Image(systemName: iconName)
                        .font(.title2)
                } else {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                }
                
                Text(activity.name ?? "Unknown")
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? activity.color.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundStyle(isSelected ? activity.color : .secondary)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? activity.color : Color.clear, lineWidth: 2)
            )
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AnalyticsFilterView { filterData in
        print("Filter changed:")
        print("- Start: \(filterData.startDate)")
        print("- End: \(filterData.endDate)")
        print("- Show Free Time: \(filterData.showFreeTime)")
        print("- Activities: \(filterData.selectedActivityIds)")
    }
    .modelContainer(for: Activity.self, inMemory: true)
    .padding()
}
