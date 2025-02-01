//
//  PeriodRow.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import SwiftUI
import PittariTimerKit

struct PeriodRow: View {
    let period: SchoolPeriod
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(period.subject)
                .font(.headline)
            Text("\(formatTime(period.startTime)) - \(formatTime(period.endTime))")
                .font(.subheadline)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
