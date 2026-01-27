//
//  DayPickerView.swift
//  Stiint
//
//  Created by Wittig, Liam on 15.12.25.
//

import SwiftUI

struct DayPickerView: View {
    @Binding var selectedDays: Set<Weekday>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack { // Updated from NavigationView (deprecated)
            List {
                // Moving the text inside the List as a Section header
                // ensures it scrolls naturally and shares the background.
                Section {
                    ForEach(Weekday.allCases) { day in
                        HStack {
                            Text(day.title)
                            Spacer()
                            if selectedDays.contains(day) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.selection)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggle(day)
                        }
                        
                    }
                } header: {
                    Text("This activity can only be triggered on selected days. On other days, it won’t start automatically when triggered, but you can still start or stop it manually.")
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 20)) // Align with title
                        .textCase(nil) // Keeps the casing as written
                }
            }
            
            .sensoryFeedback(.selection, trigger: selectedDays)
            .navigationTitle("Triggable days ")
            // This is the magic line that fixes the "background bug"
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func toggle(_ day: Weekday) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
}
