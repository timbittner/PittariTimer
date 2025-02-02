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
          VStack {
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
            Button(action: { manager.loadDefaultSchedule() }) {
              Text(NSLocalizedString("settings.button.reset_default", bundle: .pittariTimerKit, comment: ""))
                       .foregroundColor(Color(uiColor: .systemRed))
                       .padding()
                       .frame(maxWidth: .infinity)
                   }
                   .buttonStyle(.bordered)
                   .padding()
          }
          .navigationTitle(NSLocalizedString("settings.nav_title", bundle: .pittariTimerKit, comment: ""))
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
                  Button(NSLocalizedString("button.done", bundle: .pittariTimerKit, comment: "")) {
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
