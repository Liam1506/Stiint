//
//  ExportActivityLogsAsCSV.swift
//  Stiint
//
//  Created by Liam Wittig on 25.01.26.
//

import AppIntents
import Foundation
import SwiftData

// Define the result struct that will be returned by the intent

// Define the App Intent
struct ExportActivityLogsAsCSV: AppIntent {
    static var title: LocalizedStringResource = "Get a CSV File of all Activities"
    static var description = IntentDescription(
        "Get all activities including metadata as a CSV file."
    )

    func perform() async throws -> some IntentResult & ReturnsValue<URL> {
        // Fetch all activity logs
        let logs = await PersistenceManager.shared.activityLogActor.getAllActivityLogs()

        // Export to CSV
        let fileUrl = try await CsvHandler().exportDataAsCsv(logs: logs)

        return .result(value: fileUrl)
    }
}
