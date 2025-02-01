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
    VStack(spacing: 12) {
      VStack {
        Text("aktuelle Zeit und Unterrichtsstunde")
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        HStack(alignment: .lastTextBaseline) {
          Text(Date.now, format: .dateTime.hour().minute().second())
            .font(.system(size: 42, weight: .regular, design: .rounded))
            .monospacedDigit()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
          
          Spacer()
          
          Text(manager.currentPeriod?.subject ??
            (manager.nextPeriod != nil ? "Pause" : "Feierabend"))
            .font(.system(size: 42, weight: .regular, design: .rounded))
            .foregroundColor(.blue)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }

      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
      .padding(.horizontal, 12)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      
      VStack {
        Text("Zeit bis zum Ende der Stunde/Pause")
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        Text(formatTimeInterval(manager.timeToNextBreak))
          .font(.system(size: 48, weight: .regular))
          .foregroundColor(.red)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
      .padding(.horizontal, 12)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    .padding(8)
    
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

#Preview {
  PittariTimerAppView()
}

