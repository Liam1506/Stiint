//
//  CreateActivity.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI

struct CreateActivity: View {
    @Environment(\.dismiss) private var dismiss
    @State private var activityName: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Activity Name", text: $activityName)
                            .textFieldStyle(.roundedBorder)  // Native-looking field
                            .padding(.horizontal)
                            .autocapitalization(.words)
                
                Spacer()
                  
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()  // Close the sheet
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                                  Button(action: {
                                      Task{
                                        await PersistenceManager.shared.activityActor.addActivity(name: activityName)
                                          
                                    }
                                    dismiss()
                                  }) {
                                    Text("Create")
                                  }
                                  .disabled(activityName.trimmingCharacters(in: .whitespaces).isEmpty)
                              }
            }
        }
    }
}

#Preview {
    CreateActivity()
}
