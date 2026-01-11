//
//  IsActivityRunning.swift
//  Stiint
//
//  Created by Wittig, Liam on 20.12.25.
//

import AppIntents
import Foundation

struct IsActivityRunning: AppIntent {
    static var title: LocalizedStringResource = "Is activity running?"
    static var description = IntentDescription(
        "Checks, if the selected activity is currently running."
    )

    @Parameter(title: "Activity")
    var activity: ActivityEntity

    func perform() throws -> some IntentResult & ReturnsValue<Bool> {
        guard RunningManager.shared.activityDTO?.id != nil else {
            return .result(value: false)
        }

        return .result(value: RunningManager.shared.activityDTO?.id == activity.id)
    }
}
