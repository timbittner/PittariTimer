//
//  RectangularComplicationView.swift
//  PittariTimer
//
//  Created by Tim Bittner on 02.02.25.
//


import SwiftUI
import WidgetKit
import PittariTimerKit

struct RectangularComplicationView: View {
  var entry: PittariTimerEntry
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack(alignment: .lastTextBaseline, spacing: 4) {
        Text("aktuell:")
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
        Spacer(minLength: 4)
        Text(entry.period?.subject ??
             (entry.timeToNextBreak > 0 ? "Pause" : "Feierabend"))
          .font(.system(size: 20, weight: .medium))
          .minimumScaleFactor(0.5)
          .lineLimit(1)
      }
      
      HStack(alignment: .lastTextBaseline, spacing: 4) {
        Text("verbleibend:")
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
        Spacer(minLength: 4)
        Text(formatTimeInterval(entry.timeToNextBreak))
          .font(.system(size: 20, weight: .medium))
          .monospacedDigit()
          .minimumScaleFactor(0.5)
          .lineLimit(1)
      }
    }
  }

  
  private func formatTimeInterval(_ interval: TimeInterval) -> String {
    let minutes = Int(interval) / 60
    return String(format: "%d min", minutes)
  }
}
