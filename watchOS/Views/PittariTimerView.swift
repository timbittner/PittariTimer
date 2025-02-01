//
//  PittariTimerView.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import SwiftUI
import PittariTimerKit

struct PittariTimerView: View {
    @StateObject private var manager = PittariTimerManager()
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text(Date(), style: .time)
                    .font(.system(size: 32, weight: .medium))
                Text("\(manager.currentPeriod?.number ?? 0). Stunde")
                    .foregroundColor(.blue)
            }
            
            VStack {
                Text("Zeit bis zum Ende der Stunde/Pause")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                
                Text(formatTimeInterval(manager.timeToNextBreak))
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return "\(minutes) Minuten \(seconds) Sekunden"
    }
}
