//
//  PittariTimerManager.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//
import Foundation
import Combine
import WatchConnectivity
import WidgetKit

private let appGroupId = "group.systems.bittner.PittariTimer"
private let sharedDefaults = UserDefaults(suiteName: "group.systems.bittner.PittariTimer")

public class PittariTimerManager: NSObject, ObservableObject {
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
  
  
  public override init() {
    // First try to load from shared app group UserDefaults
    if let data = sharedDefaults?.data(forKey: scheduleKey),
       let savedSchedule = try? JSONDecoder().decode([SchoolPeriod].self, from: data) {
      self.schedule = savedSchedule
    }
    // Fall back to local UserDefaults
    else if let data = UserDefaults.standard.data(forKey: scheduleKey),
            let savedSchedule = try? JSONDecoder().decode([SchoolPeriod].self, from: data) {
      self.schedule = savedSchedule
    }
    // Use default schedule as last resort
    else {
      self.schedule = defaultSchedule
      print("INFO: PittariTimer loaded default schedule - no saved schedule found")
    }
    
    super.init()
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleScheduleUpdate), name: .init("ScheduleUpdated"), object: nil)
    
    setupWatchConnectivity()
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
      timeToNextBreak = ceil(period.endTime.timeIntervalSince(now))
    } else if let next = nextPeriod {
      timeToNextBreak = ceil(next.startTime.timeIntervalSince(now))
    }
  }
  
  private func saveSchedule() {
    if let encoded = try? JSONEncoder().encode(schedule) {
      UserDefaults.standard.set(encoded, forKey: scheduleKey)
      sharedDefaults?.set(encoded, forKey: scheduleKey)
      WidgetCenter.shared.reloadAllTimelines()

#if os(iOS)
      sendScheduleToWatch()
#endif
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
  
  // In PittariTimerManager.swift, add method
  @objc private func handleScheduleUpdate(_ notification: Notification) {
    if let messageData = notification.object as? Data,
       let decodedSchedule = try? JSONDecoder().decode([SchoolPeriod].self, from: messageData) {
      DispatchQueue.main.async { [weak self] in
        self?.schedule = decodedSchedule
      }
    }
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

// MARK: - Extensions

extension PittariTimerManager: WCSessionDelegate {
  public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
  
  // iOS only delegate methods
#if os(iOS)
  public func sessionDidBecomeInactive(_ session: WCSession) {}
  public func sessionDidDeactivate(_ session: WCSession) {
    session.activate()
  }
#endif
  
  private func setupWatchConnectivity() {
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
  
#if os(watchOS)
  // Watch only receives updates. Realtime update:
  public func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    if let decodedSchedule = try? JSONDecoder().decode([SchoolPeriod].self, from: messageData) {
      DispatchQueue.main.async { [weak self] in
        self?.schedule = decodedSchedule
      }
    }
  }
  
  // Delayed update:
  public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    if let encoded = applicationContext["schedule"] as? Data,
       let decodedSchedule = try? JSONDecoder().decode([SchoolPeriod].self, from: encoded) {
      DispatchQueue.main.async { [weak self] in
        self?.schedule = decodedSchedule
      }
    }
  }
  
#else
  // iOS sends updates
  private func sendScheduleToWatch() {
    guard WCSession.default.activationState == .activated else { return }
    
    if let encoded = try? JSONEncoder().encode(schedule) {
      // Send immediate message if watch is reachable
      if WCSession.default.isReachable {
        WCSession.default.sendMessageData(encoded, replyHandler: nil) { error in
          print("Error sending schedule to watch:", error.localizedDescription)
        }
      }
      
      // Also transfer for background delivery
      let userInfo = ["schedule": encoded]
      try? WCSession.default.updateApplicationContext(userInfo)
    }
  }
#endif
}

