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
        Text(NSLocalizedString("ios_subheadline_time_and_subject", bundle: .pittariTimerKit, comment: ""))
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
               (manager.nextPeriod != nil ? NSLocalizedString("pause", bundle: .pittariTimerKit, comment: "") :
                  NSLocalizedString("no_more_subject", bundle: .pittariTimerKit, comment: "")))
            .font(.system(size: 42, weight: .regular, design: .rounded))
            .foregroundColor(Color.accentColor)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }

      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
      .padding(.horizontal, 12)
      .background(Color(uiColor: .systemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 6))
      
      VStack {
        Text(NSLocalizedString("ios_subheadline_time_remaining", bundle: .pittariTimerKit, comment: ""))
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        Text(TimeFormatting.formatWithSeconds(manager.timeToNextBreak))
          .font(.system(size: 48, weight: .regular))
          .foregroundColor(Color(uiColor: .systemRed))
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
      .padding(.horizontal, 12)
      .background(Color(uiColor: .systemBackground))
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
}

#Preview {
  PittariTimerAppView()
}

