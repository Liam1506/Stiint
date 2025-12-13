# Stiint

## Concept

Stiint is a hands-off time-tracking iOS app designed to give users detailed insights into how they spend their time. It combines location-based tracking with activity tracking, allowing both automated and user-triggered entries.

The app is structured around **two main concepts**:

### 1. Locations

- Users define a **standard set of locations** (up to 20), such as Home, Work, or Gym.
- Geofencing is used for these locations to provide **precise, automated timeline entries**.
- All other locations are tracked **dynamically**: if the user stops traveling and no standard location is active for more than 10 minutes, the app retrieves the current location and its type using the Apple Maps API.
- Locations can serve as triggers for activities, but this is optional.

### 2. Activities

- Activities mostly trigger via **iOS Shortcuts**, allowing users to start an activity based on app usage, time of day, or other events.
- Example: Opening Instagram can trigger the activity “Wasted Time.”
- Activities can be **bound to a location**, but this is optional.
- Users can also manually start activities if needed.

### Home Screen Timeline

- The home screen shows a **calendar-style timeline** composed of **blocks representing locations**.
- **Activities are nested inside each location block**, showing what the user did while at that location.
- If a location is visited but no activity is triggered, the block simply shows the location.
- This design allows a **clear visual mapping** of both location and activity throughout the day.

## Key Features

- Geofenced and dynamic location tracking.
- Shortcut-driven activity tracking for minimal user intervention.
- Activities optionally linked to locations.
- Calendar-style timeline with location blocks and nested activities.
- Predefined locations limited to 20 for battery efficiency.
- Automatic location type inference for non-standard locations via Apple Maps API.

## Privacy

- All tracking is **on-device** and fully private.
- No data is shared externally unless the user chooses to export it.

## Tech Stack

- **SwiftUI** for the interface.
- **CoreLocation** for geofencing and dynamic location updates.
- **MapKit / Apple Maps API** for location type inference.
- **Shortcuts & Intents** for activity triggers.
- **Core Data / SwiftData** for storing timelines and activities.

### Flow diagrams (Sankey diagrams)

A flow-style diagram should be available for days, weeks, etc., showing how time moves between activities.

### Pie Chart

Shows the distribution of time across activities.

### Line Graphs

Illustrate changes in metrics over time and highlight trends.

## LLM (Foundation model integration)

The model should interpret parts of the metrics. Each day, an insight could be generated, with output such as: “It looks like you’re studying less than usual lately.”

## Design

The design language should feel minimalistic and native, similar to apps such as Tiimo or Finanzguru.

## Live Activities

A live activity can appear on the lock screen showing the current task, if the user enables it.

## Spotify Wrapped Feature

Users can share their yearly overview in a Spotify-Wrapped-style format to increase engagement and reach.

## Useful links:

- https://github.com/maxhumber/Sankey
- https://github.com/alessiorubicini/SFSymbolsPickerForSwiftUI
- https://www.youtube.com/watch?v=nKHrsrmA4lM (TimeLineView)
- https://www.reddit.com/r/iosapps/comments/1n2cq3d/it_took_us_9_month_to_get_our_app_here/
  cd
- https://www.hackingwithswift.com/quick-start/swiftui/how-to-provide-relative-sizes-using-geometryreader
