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
           NavigationView {
               VStack{
                   
              
                   Text("When an activity is started on each subsequent day, it will neither be saved nor included in the insights.")
                       .font(.subheadline)
                       .padding()
                       .foregroundStyle(.secondary)
              
               List {
                   ForEach(Weekday.allCases) { day in
                       
                   
                           HStack {
                               Text("Every "+day.title)
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
                   
               }
               .navigationTitle("Untracked days")
               .toolbar {
                   ToolbarItem(placement: .confirmationAction) {
                       Button("Done") {
                           dismiss()
                       }
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

enum Weekday: Int, CaseIterable, Identifiable, Hashable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
    var shortTitle: String {
           switch self {
           case .monday: return "Mon"
           case .tuesday: return "Tue"
           case .wednesday: return "Wed"
           case .thursday: return "Thu"
           case .friday: return "Fri"
           case .saturday: return "Sat"
           case .sunday: return "Sun"
           }
       }
}
