//
//  CreateActivityView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import SwiftUI


struct CreateActivityView: View {
    // MARK: - State Variables
    @Environment(\.dismiss) var dismiss
    @State private var activityName: String = ""
    @State private var selectedColor: Color = .cyan
    @State private var selectedIcon: String = "book.fill"
    @State private var showDayPicker = false
    @State private var showAlert = false
    
    
    let activityToEdit: ActivityItem?

    init(activityToEdit: ActivityItem? = nil) {
        self.activityToEdit = activityToEdit

    }
    
    private var trackedDaysText: String {
        if selectedDays.isEmpty {
            return "None"
        }

        return selectedDays
            .sorted { $0.rawValue < $1.rawValue }
            .map { $0.shortTitle }
            .joined(separator: ", ")
    }
    
    @State private var selectedDays: Set<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    // Data Sources
    let colors: [Color] = [
        .cyan, .red, .orange, .yellow, .green,  .purple, .brown, .gray, .pink, .indigo
    ]
    
    // Datenquelle für Aktivitäten-Icons
        let icons: [String] = [
            // 1. Lernen & Fokus (Deine Priorität)
            "book.fill",                // Lesen / Lernen
            "graduationcap.fill",       // Studium / Abschluss
            "desktopcomputer",          // Arbeit / Programmieren
            "pencil.and.ruler.fill",    // Entwerfen / Hausaufgaben
            "brain.head.profile",       // Nachdenken / Mentale Arbeit
            "lightbulb.fill",           // Ideenfindung
            
            // 2. Sport & Gesundheit
            "dumbbell.fill",            // Krafttraining
            "figure.run",               // Laufen / Joggen
            "figure.mind.and.body",     // Yoga / Meditation
            "bicycle",                  // Radfahren
            "waterbottle.fill",         // Trinken / Gesundheit
            "bed.double.fill",          // Schlaf / Ruhe
            
            // 3. Kreativität & Hobbys
            "paintpalette.fill",        // Malen / Kunst
            "guitars.fill",             // Musik machen
            "camera.fill",              // Fotografie
            "gamecontroller.fill",      // Gaming
            "headphones",               // Musik hören / Podcast
            "airplane",                 // Reisen
            
            // 4. Alltag & Haushalt
            "cart.fill",                // Einkaufen
            "leaf.fill",                // Garten / Natur
            "pawprint.fill",            // Hund / Haustier
            "cup.and.saucer.fill",      // Kaffeepause
            "fork.knife",               // Kochen / Essen
            "washer.fill",               // Wäsche / Haushalt
            
            // 2. Mobilität & Fortbewegung (Neu hinzugefügt)
            "car.fill",                 // Autofahren (Dein Wunsch)
            "tram.fill",                // Öffentliche Verkehrsmittel
            "bus.fill",                 // Bus
            "envelope.fill",             // Roller / E-Scooter
            "figure.walk",              // Spaziergang / Gehen
            "figure.roll",              // Rollstuhl / Mobilitätshilfe
            
            "app.badge.clock",
            "nosign.app",
            "app.dashed",
            "powersleep",
            "sleep",
            
            "wifi",
            "house.badge.wifi",
            "mappin.and.ellipse",
            "fuelpump.fill",
            "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill",
            
            "heart.fill",
            "heart.text.clipboard.fill",
            "building.2.fill",
            "building.columns.fill",
            "figure.walk.suitcase.rolling"
        ]
    
    // Grid Layout
    let columns = [
        GridItem(.adaptive(minimum: 45), spacing: 15)
    ]

    func saveEditedActivity() {
        Task{
            
        
            await PersistenceManager.shared.activityActor.editActivityById(activityId: activityToEdit!.id!, newName: activityName, newColor: selectedColor, newIcon: selectedIcon,weekdays: selectedDays)

            dismiss()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // 1. Segmented Control
                 
                        // 2. Preview Card
                        VStack(spacing: 20) {
                            // Big Icon Circle
                            ZStack {
                                Circle()
                                    .fill(selectedColor)
                                    .frame(width: 90, height: 90)
                                    .shadow(color: selectedColor.opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: selectedIcon)
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 20)
                            
                            // Text Field
                            TextField("Activity Name", text: $activityName)
                                .font(.system(size: 20, weight: .bold))
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color(uiColor: .tertiarySystemFill))
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        Button {
                            showDayPicker.toggle()
                        } label: {
                            HStack{
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Triggable days:")
                                    Text(trackedDaysText)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "pencil")
                            }
                            .contentShape(.rect)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal)

                        
                        // 4. Color Picker Grid
                        VStack {
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(colors, id: \.self) { color in
                                    ZStack {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 42, height: 42)
                                        
                                        if selectedColor.toHex() == color.toHex() {
                                            Circle()
                                                .stroke(Color(uiColor: .label).opacity(0.6), lineWidth: 3)
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.snappy) {
                                            selectedColor = color
                                        }
                                    }.frame(width: 52, height: 52)
                                }
                            }
                            .padding()
                        }
                        
                        .background(.regularMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // 5. Icon Picker Grid
                        VStack {
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(icons, id: \.self) { icon in
                                    ZStack {
                                        Circle()
                                            .fill(Color(uiColor: .tertiarySystemFill))
                                        
                                        .frame(width: 48, height: 48)
                                        
                                    
                                           
                                        
                                        Image(systemName: icon)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.primary)
                                          
                                        if selectedIcon == icon {
                                            Circle()
                                                .stroke(Color(uiColor: .label).opacity(0.6), lineWidth: 3)
                                        }
                                    }
                                    .onTapGesture {
                                        selectedIcon = icon
                                    }.frame(width: 52, height: 52)
                                }
                            }
                            .padding()
                        }
                        .background(.regularMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Bottom spacing
                        Spacer(minLength: 50)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle(activityToEdit == nil ? "New Activity" : "Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        
                        if activityToEdit?.id != nil {
                            saveEditedActivity()
                    
                        }else{
                            Task{
                                await PersistenceManager.shared.activityActor.addActivity(name: activityName, color: selectedColor, icon: selectedIcon, weekdays: selectedDays )
                                showAlert.toggle()
                                
                             
                          }
                        }
                  
                        
                    }
                        .fontWeight(.bold)
                        .disabled(activityName.isEmpty) // Disable if no name
                }
            }.onAppear {
                if let activity = activityToEdit {
                    print("Updating")
                    activityName = activity.name ?? ""
                    selectedColor = activity.color
                    print(activity.color)
                    selectedIcon = activity.sfSymbolName ?? ""
                    selectedDays = activity.weekdays ?? []
                }
            }.sheet(isPresented: $showDayPicker) {
                DayPickerView(
                    selectedDays: $selectedDays
                )
            }.alert("What would you like to do?", isPresented: $showAlert) {
                Button("Create Automation Now", role: .confirm) {
                    // Handle creating the automation
                    openAutomationPage()
                    dismiss()
                }
                Button("Do It Later", role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    CreateActivityView(activityToEdit: nil)
}
