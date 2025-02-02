//
//  PittariTimerApp.swift
//  PittariTimer Watch App
//
//  Created by Tim Bittner on 01.02.25.
//

import SwiftUI
import WatchConnectivity
import PittariTimerKit

@main
struct PittariTimerWatchApp: App {
  
  @StateObject private var manager = PittariTimerManager()
  
  var body: some Scene {
    WindowGroup {
      PittariTimerView()
        .environmentObject(manager)
    }
  }
}
