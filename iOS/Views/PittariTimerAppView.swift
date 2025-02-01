//
//  PittariTimerAppView.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import SwiftUI
import PittariTimerKit

struct PittariTimerAppView: View {
  @StateObject private var manager = PittariTimerManager()
  @State private var showingSettings: Bool = false
  
  var body: some View {
    VStack {
      Text("Current Session")
        .font(.title)
      Text(
       manager.currentPeriod?.subject ??
       (manager.nextPeriod != nil ? "Pause" : "Feierabend")
      )
      .font(.headline)
      Text(formatTimeInterval(manager.timeToNextBreak))
        .foregroundColor(.secondary)
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: {showingSettings = true}) {
          Image(systemName: "gear")
        }
      }
      ToolbarItem(placement: .navigationBarLeading) {
        Button(action: { manager.loadDebugSchedule() }) {
          Image(systemName: "ladybug")
        }
      }
    }
    .sheet(isPresented: $showingSettings) {
      SettingsView(manager: manager)
    }
  }
  
  private func formatTimeInterval(_ interval: TimeInterval) -> String {
    let minutes = Int(interval) / 60
    let seconds = Int(interval) % 60
    return String(format: "%02dm %02ds", minutes, seconds)
  }
}
