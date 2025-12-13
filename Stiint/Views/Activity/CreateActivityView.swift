//
//  CreateActivityView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import SwiftUI

import SwiftUI

struct CreateActivityView: View {
    // MARK: - State Variables
    @Environment(\.dismiss) var dismiss
    @State private var activityName: String = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedIcon: String = "book.fill"
    
    // Data Sources
    let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .brown, .gray, .pink, .indigo
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
        ]
    
    // Grid Layout
    let columns = [
        GridItem(.adaptive(minimum: 45), spacing: 15)
    ]

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
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // 3. List Type Row
                 
                        // 4. Color Picker Grid
                        VStack {
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(colors, id: \.self) { color in
                                    ZStack {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 42, height: 42)
                                        
                                        if selectedColor == color {
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
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        
                        Task{
                            await PersistenceManager.shared.activityActor.addActivity(name: activityName, color: selectedColor, icon: selectedIcon)
                            
                            dismiss()
                      }
                        
                    }
                        .fontWeight(.bold)
                        .disabled(activityName.isEmpty) // Disable if no name
                }
            }
        }
    }
}

#Preview {
    CreateActivityView()
}
