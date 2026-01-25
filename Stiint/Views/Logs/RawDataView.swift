//
//  RawDataView.swift
//  Stiint
//
//  Created by Liam Wittig on 25.01.26.
//

import SwiftUI

struct RawDataView: View {

    let dateFormatter = ISO8601DateFormatter()
    let logs: [ActivityLog]
    
    @State private var serachTerm: String = ""
    
    var searchedLog: [ActivityLog] {
        guard serachTerm != "" else { return logs }
        return logs.filter { log in
            log.activity?.name?.lowercased().contains(serachTerm.lowercased()) ?? false
        }
    }

    @State private var csvURL: URL?
    
    @State private var selectedLog: ActivityLog?

    var body: some View {
        if(searchedLog.isEmpty){
            
            ContentUnavailableView("No logs found", systemImage: "questionmark.app")
        }
        List(searchedLog) { log in
            if let endTime = log.endTime,
               let startTime = log.startTime {

                VStack(alignment: .leading) {

                    HStack {
                        Text(log.activity?.name ?? "No name")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(endTime.timeIntervalSince(startTime))s")
                            .font(.footnote)
                    }

                    HStack {
                        Text(dateFormatter.string(from: startTime))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(dateFormatter.string(from: endTime))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let startLat = log.startLatitude, let startLon = log.startLongitude, let endLat = log.endLatitude, let endLon = log.endLongitude {
                        
                        
                        HStack {
                                // Start coordinates
                                Text("\(startLat, specifier: "%.4f")° \(startLat >= 0 ? "N" : "S"), \(startLon, specifier: "%.4f")° \(startLon >= 0 ? "E" : "W")")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                                   Spacer()
                                // End coordinates
                                Text("\(endLat, specifier: "%.4f")° \(endLat >= 0 ? "N" : "S"), \(endLon, specifier: "%.4f")° \(endLon >= 0 ? "E" : "W")")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedLog = log
                }
            }
        }.searchable(text: $serachTerm)
        .sheet(item: $selectedLog) { log in
            NavigationStack {
                LogDetailView(log: log)
            }
        }
        .onAppear {
            Task {
                csvURL = try? await CsvHandler()
                    .exportDataAsCsv(logs: logs)
            }
        }
        .navigationTitle("Raw Data")
        .toolbar {
            ToolbarItem {
                if let csvURL = csvURL {
                    ShareLink(
                        item: csvURL,
                        preview: SharePreview(
                            "Data Export",
                            image: Image(systemName: "tablecells")
                        )
                    )
                } else {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    RawDataView(logs: [ActivityLog()])
}
