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
                TextField("Subject", text: $subject)
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
            }
            .navigationTitle("Add Period")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
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
