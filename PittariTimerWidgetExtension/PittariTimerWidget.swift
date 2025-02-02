//
//  PittariTimerWidget.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import WidgetKit
import SwiftUI
import PittariTimerKit

struct Provider: TimelineProvider {
  
  typealias Entry = PittariTimerEntry
  
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
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let currentDate = Date()
    var entries: [PittariTimerEntry] = []
    
    // Create entries for the next hour, updating every minute
    for minuteOffset in 0..<60 {
      let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
      let currentPeriod = getCurrentPeriod(at: entryDate)
      let timeToNext = getTimeToNextBreak(at: entryDate, currentPeriod: currentPeriod)
      
      let entry = PittariTimerEntry(
        date: entryDate,
        period: currentPeriod,
        timeToNextBreak: timeToNext
      )
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (PittariTimerEntry) -> ()) {
    let currentDate = Date()
    let currentPeriod = getCurrentPeriod(at: currentDate)
    let timeToNext = getTimeToNextBreak(at: currentDate, currentPeriod: currentPeriod)
    
    let entry = PittariTimerEntry(
      date: currentDate,
      period: currentPeriod,
      timeToNextBreak: timeToNext
    )
    completion(entry)
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
}

struct PittariTimerEntry: TimelineEntry {
  let date: Date
  let period: SchoolPeriod?
  let timeToNextBreak: TimeInterval
}

@main
struct PittariTimerWidget: Widget {
  let kind: String = "PittariTimerWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(watchOS 10.0, *) {
        PittariTimerWidgetView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        PittariTimerWidgetView(entry: entry)
      }
    }
    .configurationDisplayName("PittariTimer")
    .description("Shows current period and time to next break")
    .supportedFamilies([.accessoryRectangular, .accessoryCorner])
  }
}

struct PittariTimerWidgetView: View {
  var entry: Provider.Entry
  
  var body: some View {
    VStack {
      switch entry.period {
      case .some(let period):
        VStack(alignment: .leading) {
          Text(period.subject)
            .font(.headline)
            .lineLimit(1)
          Text(formatTimeInterval(entry.timeToNextBreak))
            .font(.system(.body, design: .rounded))
            .foregroundStyle(.red)
        }
      case .none:
        Text(formatTimeInterval(entry.timeToNextBreak))
          .font(.system(.headline, design: .rounded))
          .foregroundStyle(.red)
      }
    }
  }
  
  private func formatTimeInterval(_ interval: TimeInterval) -> String {
    let minutes = Int(interval) / 60
    let seconds = Int(interval) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
