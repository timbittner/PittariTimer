//
//  PittariTimerView.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import SwiftUI
import PittariTimerKit

struct PittariTimerView: View {
  @EnvironmentObject private var manager: PittariTimerManager

  var body: some View {
    VStack(spacing: 16) {
      
      Text(Date.now, format: .dateTime.hour().minute().second())
        .font(.system(size: 42, weight: .regular, design: .rounded))
        .monospacedDigit()
        .minimumScaleFactor(0.85)
        .lineLimit(1)
      
      VStack {
        Text(NSLocalizedString("watch_subheadline_subject", bundle: .pittariTimerKit, comment: ""))
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        Text(manager.currentPeriod?.subject ??
             (manager.nextPeriod != nil ? NSLocalizedString("pause", bundle: .pittariTimerKit, comment: "") : NSLocalizedString("no_more_subject", bundle: .pittariTimerKit, comment: "")))
        .font(.system(size: 42, weight: .regular, design: .rounded))
        .foregroundColor(.blue)
        .minimumScaleFactor(0.5)
        .lineLimit(1)
      }
      
      
      VStack {
        Text(NSLocalizedString("watch_subheadline_time_remaining", bundle: .pittariTimerKit, comment: ""))
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        Text(TimeFormatting.formatWithSeconds(manager.timeToNextBreak))
          .font(.system(size: 48, weight: .regular))
          .foregroundColor(.red)
          .minimumScaleFactor(0.5)
          .lineLimit(1)
      }
    }
    .padding()
  }
}
