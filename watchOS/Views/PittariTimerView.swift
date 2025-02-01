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
        Text("aktuell:")
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        Text(manager.currentPeriod?.subject ??
             (manager.nextPeriod != nil ? "Pause" : "Feierabend"))
        .font(.system(size: 42, weight: .regular, design: .rounded))
        .foregroundColor(.blue)
        .minimumScaleFactor(0.5)
        .lineLimit(1)
      }
      
      
      VStack {
        Text("verbleibend:")
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        Text(formatTimeInterval(manager.timeToNextBreak))
          .font(.system(size: 48, weight: .regular))
          .foregroundColor(.red)
          .minimumScaleFactor(0.5)
          .lineLimit(1)
      }
    }
    .padding()
  }
  
  private func formatTimeInterval(_ interval: TimeInterval) -> String {
    let minutes = Int(interval) / 60
    let seconds = Int(interval) % 60
    return String(format: "%02dm %02ds", minutes, seconds)
  }
}

#Preview {
  PittariTimerView()
}
