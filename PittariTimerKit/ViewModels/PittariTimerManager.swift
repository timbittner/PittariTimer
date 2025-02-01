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
      let calendar = Calendar.current
      let today = calendar.startOfDay(for: Date())
      
      schedule = [
        SchoolPeriod(number: 1,
                     startTime: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: today)!,
                     endTime: calendar.date(bySettingHour: 8, minute: 45, second: 0, of: today)!,
                     subject: "Math"),
        SchoolPeriod(number: 2,
                     startTime: calendar.date(bySettingHour: 8, minute: 50, second: 0, of: today)!,
                     endTime: calendar.date(bySettingHour: 9, minute: 35, second: 0, of: today)!,
                     subject: "English")
      ]
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
    
    if let period = currentPeriod {
      timeToNextBreak = period.endTime.timeIntervalSince(now)
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

