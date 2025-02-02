//
//  EditPeriodView.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//


import SwiftUI
import PittariTimerKit

struct EditPeriodView: View {
  let period: SchoolPeriod
  @ObservedObject var manager: PittariTimerManager
  @Environment(\.dismiss) var dismiss
  @State private var subject: String
  @State private var startTime: Date
  @State private var endTime: Date
    
  init(period: SchoolPeriod, manager: PittariTimerManager) {
    self.period = period
    self.manager = manager
    _subject = State(initialValue: period.subject)
    _startTime = State(initialValue: period.startTime)
    _endTime = State(initialValue: period.endTime)
  }
    
  var body: some View {
    Form {
      TextField(NSLocalizedString("subject", bundle: .pittariTimerKit, comment: ""), text: $subject)
      DatePicker(NSLocalizedString("start_time", bundle: .pittariTimerKit, comment: ""), selection: $startTime, displayedComponents: .hourAndMinute)
      DatePicker(NSLocalizedString("end_time", bundle: .pittariTimerKit, comment: ""), selection: $endTime, displayedComponents: .hourAndMinute)
    }
    .navigationTitle(NSLocalizedString("editperiod.nav_title", bundle: .pittariTimerKit, comment: ""))
    .toolbar {
      Button(NSLocalizedString("button.save", bundle: .pittariTimerKit, comment: "")) {
        if let index = manager.schedule.firstIndex(where: { $0.id == period.id }) {
          let updatedPeriod = SchoolPeriod(
            number: period.number,
            startTime: startTime,
            endTime: endTime,
            subject: subject
          )
          manager.schedule[index] = updatedPeriod
        }
        dismiss()
      }
    }
  }
}
