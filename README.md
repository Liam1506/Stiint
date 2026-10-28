# Stiint — Know Your Time

Stiint is an iOS time-tracking app built around iOS Shortcuts automations. Define activities, wire them up to Shortcuts triggers once, and Stiint records your day automatically — no manual input required. Review your timeline and analyze how you spend your time across any date range.

[Download on the App Store](https://apps.apple.com/de/app/stiint-know-your-time/id6756229335)

## Screenshots

<p float="left">
  <img src="docs/images/Pasted 28-10-2026 at 14.52.26.png" width="19%" />
  <img src="docs/images/Pasted 28-10-2026 at 14.53.53.png" width="19%" />
  <img src="docs/images/Pasted 28-10-2026 at 14.53.17.png" width="19%" />
  <img src="docs/images/Pasted 28-10-2026 at 14.53.10.png" width="19%" />
</p>

## How It Works

1. **Create activities** — define activities like Sleep, University, Learning, or Gym, each with a color and SF Symbol icon.
2. **Automate with Shortcuts** — use iOS Shortcuts to start and stop activities automatically. Triggers can be alarms, location arrival, app opens, time of day, or anything else Shortcuts supports.
3. **Review your timeline** — the home screen shows a scrollable calendar-style timeline. Swipe between days going back up to 2000 days.
4. **Analyze trends** — the Insights screen visualizes your data with Sankey, pie, bar, line, and area charts across a custom date range.

## App Intents (Shortcuts Actions)

Stiint exposes the following actions to iOS Shortcuts and Automations:

| Action | Description |
|---|---|
| Start an activity | Starts a specific activity. Respects weekday filters and tracking pause state. |
| Stop a specific activity | Stops a specific activity; other running activities are unaffected. |
| Stop activity and resume previous | Stops the current activity and resumes the one it interrupted, if available. |
| Get current activity | Returns the currently running activity, or nil if none is active. |
| Get all activities | Returns a list of all activities. |
| Is activity running | Returns whether a specific activity is currently active. |
| Stop activity | Stops whatever activity is currently running. |
| Export as CSV | Exports all activity logs as a CSV file. |

## Features

- **Shortcuts-driven** — all core tracking happens via App Intents; no background polling.
- **Weekday filters** — activities can be restricted to specific days of the week.
- **Location logging** — optionally records GPS coordinates at activity start and end.
- **Live Activity** — shows the current activity and elapsed time in the Dynamic Island and on the lock screen.
- **Swipeable timeline** — horizontal paging between days with lazy rendering for performance.
- **Analytics** — Sankey, pie, bar, line, and area diagrams with activity and date range filters.
- **CSV export** — full activity log export via Shortcuts.
- **Fully on-device** — all data stored locally with SwiftData; nothing sent externally.
- **Pro subscription** — pie, bar, and area charts are gated behind a StoreKit subscription.

## Usage

### 1. Create an activity

Open Stiint, tap **+** on the Start Activity screen, and give the activity a name, color, and icon. Optionally restrict it to specific weekdays.

### 2. Set up a Shortcuts automation

Open the **Shortcuts** app → **Automation** → **+** → **Create Personal Automation**. Choose a trigger:

| Trigger | Example |
|---|---|
| App opened | Start "Work" when Slack opens |
| App closed | Stop "Social" when Instagram closes |
| Arrive at location | Start "Gym" when you arrive at the gym |
| Leave location | Stop "Work" when you leave the office |
| Alarm stopped | Start "University" when your alarm fires |
| Time of day | Start "Sleep" at 10:30 PM |

Add a Stiint action (e.g. **Start an activity** or **Stop current activity**), set it to **Run Immediately**, and tap **Done**.

### 3. Review your timeline

The home screen shows a scrollable daily timeline. Swipe left/right to move between days or tap the date to jump to a specific day.

### 4. Analyze your time

Go to **Insights**, pick a date range and activities, and explore the Sankey flow diagram, pie chart, bar chart, line graph, and area chart.

## Building from Source

Clone the repo and open `Stiint.xcodeproj` in Xcode. The paywall is MIT-licensed along with the rest of the code — you are free to remove or bypass it. The subscription check lives in `SubscriptionManager.shared.isPro` (`Stiint/Service/Singeltons/subscriptionManager.swift`); the paywall gate wraps charts in `AnalyticsView` and settings in `SettingsView`.

## License

MIT © 2026 Liam Wittig. See [LICENSE](LICENSE).
