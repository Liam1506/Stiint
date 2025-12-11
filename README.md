# Stint

### Idea

The idea of the app is to provide a largely hands-off time-tracking experience on iOS. Its purpose is to help you understand where your time goes, improve your daily routine, and reduce unnecessary overhead. For example, you might want to track how long it takes you to get ready in the morning.

### Tech Stack

The app is written in SwiftUI, since it relies heavily on native functionality. Most timers should start automatically through Shortcuts. In the morning example, a timer could start when the alarm goes off and stop once you leave the house. Afterwards, a travel activity could begin, followed by a work activity, and so on. The goal is to model your day using Shortcut triggers to create an automated time-tracking workflow. Manual activities, such as studying, can still be added.

Current triggers could include:

- Trigger to start a specific activity for a certain duration

  - For example: start activity break for one hour when Apple Pay is used at a certain time

- Trigger to stop the current activity for a certain duration and the continue

- Trigger to start a specific activity

  - For example: start the “way to work” activity when leaving the house

- Trigger to stop a specific running activity
  - For example: stop “sleeping” when the alarm goes off
- Trigger to stop any activity
  - For example: when arriving back home
- Trigger to stop an activity and resume the previous one
  - Useful for short interruptions such as Instagram: start a “social media” activity when the app opens, and stop it when the app closes

If no activity is running, the app assumes free time.

Users should be able to exclude specific days from tracking, such as holidays or weekends.

### Analytics

The app should include detailed analytics. Multiple graphs should illustrate how time is spent. Users should be able to identify trends—for instance, spending less time on a hobby or working too much. Foundation models can help detect patterns. For example: commute times on Fridays are 10% longer than the rest of the week, or it usually takes around 30 minutes to reach a certain location.

### Privacy

All data stays completely local. Nothing leaves the device or iCloud. No account or login is required.

## Challenges

The biggest challenge is onboarding. The introduction must be very clear, and users must be willing to model their day once, which may take a few minutes. However, apps such as OneSec have succeeded with more demanding setups.

- A checklist could help during onboarding with basic tasks like adding sleep or work so users don’t feel they must model their entire day at once.

Another issue is the strong dependence on the Shortcuts app, which cannot be fully avoided.

- A buffer system could help make tracking more resilient, or a pattern-recognition model could prompt the user if an expected event didn’t trigger.

## Inspiration

Time should be treated like a form of currency. Visualizations should show how available time flows and is distributed, similar to tools in finance apps like Finanzguru.

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
