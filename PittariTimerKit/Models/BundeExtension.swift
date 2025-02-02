//
//  BundeExtension.swift
//  PittariTimer
//
//  Created by Tim Bittner on 02.02.25.
//


// Localization
public extension Bundle {
  static var pittariTimerKit: Bundle {
    Bundle(for: PittariTimerManager.self)
  }
}