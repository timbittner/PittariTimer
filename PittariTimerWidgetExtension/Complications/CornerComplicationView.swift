//
//  CornerComplicationView.swift
//  PittariTimer
//
//  Created by Tim Bittner on 02.02.25.
//

import SwiftUI
import WidgetKit
import PittariTimerKit

struct CornerComplicationView: View {
  var entry: PittariTimerEntry
  var style: CornerStyle
  
  var body: some View {
    switch style {
    case .stacked:
      StackedCornerView(entry: entry)
    case .gauge:
      GaugeCornerView(entry: entry)
    }
  }
}

private struct StackedCornerView: View {
  var entry: PittariTimerEntry
  
  var body: some View {
      ZStack {
        VStack {
          Text(formatTimeInterval(entry.timeToNextBreak))
            .font(.system(size: 16, weight: .medium))
            .monospacedDigit()
          Text(entry.period?.subject ?? "Pause")
            .font(.system(size: 12))
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }
      }
    }
  
  private func formatTimeInterval(_ interval: TimeInterval) -> String {
    let minutes = Int(interval) / 60
    return String(format: "%02d", minutes)
  }
}

private struct GaugeCornerView: View {
  var entry: PittariTimerEntry
    
    var progress: Double {
      guard let period = entry.period else { return 0 }
      let total = period.endTime.timeIntervalSince(period.startTime)
      let elapsed = Date().timeIntervalSince(period.startTime)
      return elapsed / total
    }
    
    var body: some View {
      Gauge(value: progress) {
        Text(entry.period?.subject.prefix(3).uppercased() ?? "---")
          .font(.system(size: 12))
      } currentValueLabel: {
        Text(formatTimeInterval(entry.timeToNextBreak))
          .font(.system(size: 16, weight: .medium))
          .monospacedDigit()
      }
    }
  
  private func formatTimeInterval(_ interval: TimeInterval) -> String {
    let minutes = Int(interval) / 60
    return String(format: "%02d", minutes)
  }
}
