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
    @State private var csvURL: URL?
    
  
    
    var body: some View {
        
        List(logs) { log in
                
            if let endTime = log.endTime, let startTime = log.startTime {
                    
                    
                VStack(alignment: .leading) {
                    HStack{
                            
                        Text(log.activity?.name ?? "No name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        Text("\(endTime.timeIntervalSince(startTime))s")
                            .font(.footnote)
                            
                    }
                    HStack(){
                            
                        Text(dateFormatter.string(from: startTime))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("-")
                            
                            .foregroundStyle(.secondary)
                            
                        Text(dateFormatter.string(from: endTime))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }}
        }.onAppear(){
            Task{
                        
                csvURL = try? await CsvHandler()
                    .exportDataAsCsv(logs: logs)
            }
        }
        .navigationTitle("Raw Data")
        .toolbar{
            ToolbarItem{
                    
                if let csvURL = csvURL {
                    ShareLink(
                        item: csvURL,
                        preview: SharePreview(
                            "Data Export",
                            image: Image(systemName: "tablecells")
                        )
                    )
                }else{
                    ProgressView()
                }
                         
            }
         
            
            
        }
    }
}

#Preview {
    RawDataView(logs: [ActivityLog()])
}
