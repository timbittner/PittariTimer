//
//  AddPeriodView.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import SwiftUI
import PittariTimerKit

struct AddPeriodView: View {
    @ObservedObject var manager: PittariTimerManager
    @Environment(\.dismiss) var dismiss
    @State private var subject = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(2700)
    
    var body: some View {
        NavigationView {
            Form {
              TextField(NSLocalizedString("subject", bundle: .pittariTimerKit, comment: ""), text: $subject)
              DatePicker(NSLocalizedString("start_time", bundle: .pittariTimerKit,  comment: ""), selection: $startTime, displayedComponents: .hourAndMinute)
              DatePicker(NSLocalizedString("end_time", bundle: .pittariTimerKit, comment: ""), selection: $endTime, displayedComponents: .hourAndMinute)
            }
            .navigationTitle(NSLocalizedString("addperiod.nav_title", bundle: .pittariTimerKit, comment: ""))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                  Button(NSLocalizedString("button.cancel", bundle: .pittariTimerKit, comment: "")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                  Button(NSLocalizedString("button.add", bundle: .pittariTimerKit, comment: "")) {
                        let newPeriod = SchoolPeriod(
                            number: manager.schedule.count + 1,
                            startTime: startTime,
                            endTime: endTime,
                            subject: subject
                        )
                        manager.addPeriod(newPeriod)
                        dismiss()
                    }
                }
            }
        }
    }
}
