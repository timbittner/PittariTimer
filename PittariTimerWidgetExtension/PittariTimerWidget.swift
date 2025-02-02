//
//  PittariTimerWidget.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import WidgetKit
import SwiftUI
import PittariTimerKit
import AppIntents


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
      subject: NSLocalizedString("widget_sample_subject", bundle: .pittariTimerKit, comment: "")
    )
    return PittariTimerEntry(
      date: Date(),
      period: samplePeriod,
      timeToNextBreak: 1800, // 30 minutes
      configuration: ConfigurationAppIntent()
    )
  }
  
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> Entry {
    let currentDate = Date()
    let currentPeriod = getCurrentPeriod(at: currentDate)
    let timeToNext = getTimeToNextBreak(at: currentDate, currentPeriod: currentPeriod)
    
    return Entry(
      date: currentDate,
      period: currentPeriod,
      timeToNextBreak: timeToNext,
      configuration: configuration
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
        timeToNextBreak: timeToNext,
        configuration: configuration
      )
      entries.append(entry)
    }
    
    return Timeline(entries: entries, policy: .atEnd)
  }
  
  func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
    return [
      AppIntentRecommendation(
        intent: ConfigurationAppIntent(),
        description: NSLocalizedString("widget_recommend_time_and_subject", bundle: .pittariTimerKit, comment: "")
      ),
      AppIntentRecommendation(
        intent: {
          let intent = ConfigurationAppIntent()
          intent.cornerStyle = .gauge
          return intent
        }(),
        description: NSLocalizedString("widget_recommend_gauge", bundle: .pittariTimerKit, comment: "")
      )
    ]
  }
}

struct PittariTimerEntry: TimelineEntry {
  let date: Date
  let period: SchoolPeriod?
  let timeToNextBreak: TimeInterval
  let configuration: ConfigurationAppIntent
}

struct PittariTimerWidgetView: View {
  var entry: Provider.Entry
  let configuration: ConfigurationAppIntent
  @Environment(\.widgetFamily) var family
  @Environment(\.widgetRenderingMode) var renderingMode
  
  private var cornerStyle: CornerStyle {
    configuration.cornerStyle
  }
  
  var body: some View {
    switch family {
    case .accessoryRectangular:
      RectangularComplicationView(entry: entry)
    case .accessoryCorner:
      // TODO: i would really like to have the outer label arc but this already took too long
      switch configuration.cornerStyle {
      case .stacked: // Time remaining on outer arc, subject on inner arc
        Text(TimeFormatting.formatMinutesOnly(entry.timeToNextBreak, short: true))
          .font(.system(size: 22, weight: .medium, design: .rounded))
          .monospacedDigit()
          .widgetLabel {
            Text(entry.period?.subject ?? NSLocalizedString("pause", bundle: .pittariTimerKit, comment: ""))
          }
        
      case .gauge: // 3-letter subject code on outer arc, time with progress gauge on inner
        var progress: Double {
          guard let period = entry.period else { return 0 }
          let total = period.endTime.timeIntervalSince(period.startTime)
          let elapsed = Date().timeIntervalSince(period.startTime)
          return elapsed / total
        }

        Text(entry.period?.subject.uppercased().prefix(3) ?? "⏸️")
          .font(.system(size: 22, weight: .medium, design: .rounded))
          .monospacedDigit()
          .widgetLabel {
            Gauge(value: progress,
                  in: 0...1) {
              Text(NSLocalizedString("widget_minutes_shorthand", bundle: .pittariTimerKit, comment: "")) // descriptor, minutes remaining
            } currentValueLabel: {
              Text("\(progress * 100, format: .percent)") // descriptor, the amount of progress made
            } minimumValueLabel: {
              Text(TimeFormatting.formatMinutesOnly(entry.timeToNextBreak)) // rendered left to the progress bar
            } maximumValueLabel: {
              Text("") // rendered right to the progress bar
            }
          }
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
  let kind: String = "widget_kind"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
      PittariTimerWidgetView(entry: entry, configuration: entry.configuration)
    }
    .configurationDisplayName(NSLocalizedString("widget_config_display_name", bundle: .pittariTimerKit, comment: ""))
    .description(NSLocalizedString("widget_config_description", bundle: .pittariTimerKit, comment: ""))
    .supportedFamilies([.accessoryRectangular, .accessoryCorner])
  }
}

