//
//  SettingsView.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//


import SwiftUI
import PittariTimerKit

struct SettingsView: View {
    @ObservedObject var manager: PittariTimerManager
    @Environment(\.dismiss) var dismiss
    @State private var showingAddPeriod = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.schedule) { period in
                    NavigationLink(destination: EditPeriodView(period: period, manager: manager)) {
                        PeriodRow(period: period)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { manager.removePeriod(at: $0) }
                }
                .onMove { source, destination in
                    manager.movePeriod(from: source, to: destination)
                }
            }
            .navigationTitle("Schedule")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPeriod = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddPeriod) {
            AddPeriodView(manager: manager)
        }
    }
}