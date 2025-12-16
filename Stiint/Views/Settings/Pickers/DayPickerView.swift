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
                   
              
                   Text("This activity can only be triggered on selected days. On other days, it won’t start automatically when triggered, but you can still start or stop it manually.")
                       .font(.subheadline)
                       .padding()
                       .foregroundStyle(.secondary)
              
               List {
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
                   
               }
               .navigationTitle("Triggable days")
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

