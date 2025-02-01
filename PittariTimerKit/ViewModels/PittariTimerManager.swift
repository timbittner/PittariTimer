//
//  PittariTimerManager.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//
import Foundation
import Combine

public class PittariTimerManager: ObservableObject {
  @Published public var currentPeriod: SchoolPeriod?
  @Published public var nextPeriod: SchoolPeriod?
  @Published public var timeToNextBreak: TimeInterval = 0
  @Published public var schedule: [SchoolPeriod] {
    didSet {
      saveSchedule()
    }
  }
  
  private var timer: Timer?
  private let scheduleKey = "savedSchedule"
  
  
  public init() {
    if let data = UserDefaults.standard.data(forKey: scheduleKey),
       let savedSchedule = try? JSONDecoder().decode([SchoolPeriod].self, from: data) {
      self.schedule = savedSchedule
    } else {
      self.schedule = defaultSchedule
    }
    
    startTimer()
  }
  
  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      self?.updateCurrentPeriod()
    }
  }
  
  private func updateCurrentPeriod() {
    let now = Date()
    currentPeriod = schedule.first { period in
      now >= period.startTime && now <= period.endTime
    }
    
    nextPeriod = schedule.first { period in
      period.startTime > now
    }
    
    if let period = currentPeriod {
      timeToNextBreak = period.endTime.timeIntervalSince(now)
    } else if let next = nextPeriod {
      timeToNextBreak = next.startTime.timeIntervalSince(now)
    }
  }
  
  private func saveSchedule() {
    if let encoded = try? JSONEncoder().encode(schedule) {
      UserDefaults.standard.set(encoded, forKey: scheduleKey)
    }
  }
  
  public func addPeriod(_ period: SchoolPeriod) {
    schedule.append(period)
  }
  
  public func removePeriod(at index: Int) {
    schedule.remove(at: index)
  }
  
  public func movePeriod(from source: IndexSet, to destination: Int) {
    var periods = schedule
    let offset = source.first!
    
    // Adjust destination index if moving forward to account for removal
    let adjustedDestination = destination > offset ? destination - 1 : destination
    
    // Remove from source
    let period = periods.remove(at: offset)
    
    // Insert at destination
    periods.insert(period, at: adjustedDestination)
    
    schedule = periods
  }
  
  public func loadDefaultSchedule() {
    schedule = defaultSchedule
  }
  
  // Mark: - DEBUG
  public func loadDebugSchedule() {
    let now = Date()
    let oneMinuteLater = now.addingTimeInterval(60)
    
    schedule = [
      SchoolPeriod(
        number: 1,
        startTime: now,
        endTime: oneMinuteLater,
        subject: "Debug Session"
      )
    ]
  }
}

