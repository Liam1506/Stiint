//
//  CsvHandler.swift
//  Stiint
//
//  Created by Liam Wittig on 11.01.26.
//

import Foundation

final class CsvHandler {
    func exportDataAsCsv(logs: [ActivityLog]) async throws -> URL {
  

        let headers = ["Activity", "Start Date", "End Date", "Duration", "Start Latitude", "Start Longitude", "End Latitude", "End Longitude"]
        var csvFile = headers.joined(separator: ",") + "\n"

        let dateFormatter = ISO8601DateFormatter()

        for log in logs {
            guard
                let activity = log.activity,
                let name = activity.name,
                let startTime = log.startTime,
                let endTime = log.endTime
            else { continue }

            let duration = endTime.timeIntervalSince(startTime)

            let row = [
                escape(name),
                escape(dateFormatter.string(from: startTime)),
                escape(dateFormatter.string(from: endTime)),
                String(duration),
                escape(log.startLatitude),
                escape(log.startLongitude),
                escape(log.endLatitude),
                escape(log.endLongitude),
            ]

            csvFile += row.joined(separator: ",") + "\n"
        }

        return try save(csvFile)
    }

    // MARK: - Helpers

    private func escape(_ value: Any?) -> String {
        guard let value else { return "\"\"" }  // empty CSV cell
        let escaped = String(describing: value)
            .replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }
    
    private func save(_ csv: String) throws -> URL {
        let fileName = "activity_logs.csv"

        let documentsURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        let fileURL = documentsURL.appendingPathComponent(fileName)

        try csv.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }
}
