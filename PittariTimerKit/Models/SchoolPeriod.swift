//
//  SchoolPeriod.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import Foundation

public struct SchoolPeriod: Identifiable, Codable, Equatable {
  public let id: UUID
  public let number: Int
  public let startTime: Date
  public let endTime: Date
  public let subject: String
  
  public init(number: Int, startTime: Date, endTime: Date, subject: String) {
    self.id = UUID()
    self.number = number
    self.startTime = startTime
    self.endTime = endTime
    self.subject = subject
  }
}
