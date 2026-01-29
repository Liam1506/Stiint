//
//  DaySelectionSheet.swift
//  Stiint
//
//  Created by Liam Wittig on 25.01.26.
//
import SwiftUI

struct DaySelectionSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var date: Date
    
    let dayRange: Int
    
    let calendar = Calendar.current
    let today = Date.now
    
    var body: some View {
        NavigationStack {
                DatePicker(
                    "Start Date",
                    selection: $date,
                    in: calendar.date(byAdding: .day, value: dayRange, to: today)! ... today,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                .frame(minHeight: 400)
                
            
            .navigationTitle("Pick Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Today") {
                        date = Date.now
                        DispatchQueue.main.async { dismiss() }
                    }
                    .tint(.blue)
                    .disabled(date > calendar.startOfDay(for: today))
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .glassEffect()
                }
            }
            .interactiveDismissDisabled(false)
            .presentationDetents([.medium])
        }
    }
}
