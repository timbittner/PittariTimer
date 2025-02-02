//
//  PittariTimerWidget.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import WidgetKit
import SwiftUI
import PittariTimerKit


struct Provider: AppIntentTimelineProvider {
  
  typealias Entry = PittariTimerEntry
  typealias Intent = ConfigurationAppIntent
  
  private let sharedDefaults = UserDefaults(suiteName: "group.systems.bittner.PittariTimer")
  private let scheduleKey = "savedSchedule"
  
  public var schedule: [SchoolPeriod] {
    if let data = sharedDefaults?.data(forKey: scheduleKey) {
      if let savedSchedule = try? JSONDecoder().decode([SchoolPeriod].self, from: data) {
        return savedSchedule
      } 
    }
    return []
  }
  
  private func getCurrentPeriod(at date: Date) -> SchoolPeriod? {
    schedule.first { period in
      date >= period.startTime && date <= period.endTime
    }
  }
  
  private func getNextPeriod(at date: Date) -> SchoolPeriod? {
    schedule.first { period in
      period.startTime > date
    }
  }
  
  private func getTimeToNextBreak(at date: Date, currentPeriod: SchoolPeriod?) -> TimeInterval {
    if let period = currentPeriod {
      return period.endTime.timeIntervalSince(date)
    } else if let next = getNextPeriod(at: date) {
      return next.startTime.timeIntervalSince(date)
    }
    return 0
  }
  
  func placeholder(in context: Context) -> PittariTimerEntry {
    // Create a sample entry for previews/placeholders
    let samplePeriod = SchoolPeriod(
      number: 1,
      startTime: Date(),
      endTime: Date().addingTimeInterval(3600),
      subject: "Sample Class"
    )
    return PittariTimerEntry(
      date: Date(),
      period: samplePeriod,
      timeToNextBreak: 1800 // 30 minutes
    )
  }
  
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> Entry {
    let currentDate = Date()
    let currentPeriod = getCurrentPeriod(at: currentDate)
    let timeToNext = getTimeToNextBreak(at: currentDate, currentPeriod: currentPeriod)
    
    return Entry(
      date: currentDate,
      period: currentPeriod,
      timeToNextBreak: timeToNext
    )
  }
  
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<Entry> {
    let currentDate = Date()
    var entries: [Entry] = []
    
    // Create entries for the next hour, updating every minute
    for minuteOffset in 0..<60 {
      let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
      let currentPeriod = getCurrentPeriod(at: entryDate)
      let timeToNext = getTimeToNextBreak(at: entryDate, currentPeriod: currentPeriod)
      
      let entry = Entry(
        date: entryDate,
        period: currentPeriod,
        timeToNextBreak: timeToNext
      )
      entries.append(entry)
    }
    
    return Timeline(entries: entries, policy: .atEnd)
  }
  
  func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
    [
        AppIntentRecommendation(
          intent: ConfigurationAppIntent(),
          description: "Time and Subject"
        ),
        AppIntentRecommendation(
          intent: {
            var intent = ConfigurationAppIntent()
            intent.cornerStyle = .gauge
            return intent
          }(),
          description: "Progress Gauge"
        )
      ]
  }
}

struct PittariTimerEntry: TimelineEntry {
  let date: Date
  let period: SchoolPeriod?
  let timeToNextBreak: TimeInterval
}

struct PittariTimerWidgetView: View {
  var entry: Provider.Entry
  @Environment(\.widgetFamily) var family
  @Environment(\.widgetRenderingMode) var renderingMode
  
  private var cornerStyle: CornerStyle {
    // TODO: Get configuration choice
    .stacked  // Default for now
  }
  
  var body: some View {
    switch family {
    case .accessoryRectangular:
      RectangularComplicationView(entry: entry)
    case .accessoryCorner:
      if renderingMode == .fullColor {
        CornerComplicationView(entry: entry, style: cornerStyle)
      } else {
        CornerComplicationView(entry: entry, style: .stacked)
      }
    case .accessoryCircular, .accessoryInline:
      Text("Not supported")
    @unknown default:
      Text("Not supported")
    }
  }
}

@main
struct PittariTimerWidget: Widget {
  let kind: String = "PittariTimerWidget"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
      PittariTimerWidgetView(entry: entry)
    }
    .configurationDisplayName("PittariTimer")
    .description("Shows current period and time to next break")
    .supportedFamilies([.accessoryRectangular, .accessoryCorner])
  }
}

