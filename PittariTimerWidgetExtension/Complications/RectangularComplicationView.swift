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
        Text(NSLocalizedString("widget_r_subheadline_subject", bundle: .pittariTimerKit, comment: ""))
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
        Spacer(minLength: 4)
        Text(entry.period?.subject ??
             (entry.timeToNextBreak > 0 ? "pause" : "no_more_subejct"))
          .font(.system(size: 20, weight: .medium))
          .minimumScaleFactor(0.5)
          .lineLimit(1)
      }
      
      HStack(alignment: .lastTextBaseline, spacing: 4) {
        Text(NSLocalizedString("widget_r_subheadline_time_remaining", bundle: .pittariTimerKit, comment: ""))
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
        Spacer(minLength: 4)
        Text(TimeFormatting.formatMinutesOnly(entry.timeToNextBreak))
          .font(.system(size: 20, weight: .medium))
          .monospacedDigit()
          .minimumScaleFactor(0.5)
          .lineLimit(1)
      }
    }
  }
}
