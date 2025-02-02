//
//  TimeFormatting.swift
//  PittariTimer
//
//  Created by Tim Bittner on 02.02.25.
//


public enum TimeFormatting {
  public static func formatWithSeconds(_ interval: TimeInterval) -> String {
    let minutes = Int(interval) / 60
    let seconds = Int(interval) % 60
    return String(format: NSLocalizedString("time.format.with_seconds", 
      bundle: .pittariTimerKit,
      comment: "Format: 5m 30s"), 
      minutes, 
      seconds)
  }
  
  public static func formatMinutesOnly(_ interval: TimeInterval, short: Bool = false) -> String {
    let minutes = Int(interval) / 60
    return String(format: NSLocalizedString(
      short ? "time.format.minutes_short" : "time.format.minutes_only",
      bundle: .pittariTimerKit,
      comment: "Format: 5 min"),
      minutes)
  }
}
