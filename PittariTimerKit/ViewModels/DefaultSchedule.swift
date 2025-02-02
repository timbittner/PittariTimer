//
//  DefaultSchedule.swift
//  PittariTimer
//
//  Created by Tim Bittner on 01.02.25.
//

import Foundation

let calendar = Calendar.current
let today = calendar.startOfDay(for: Date())
public let defaultSchedule : [SchoolPeriod] = [
  SchoolPeriod(number: 1,
    startTime: calendar.date(bySettingHour: 7, minute: 55, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 8, minute: 40, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_1", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 2,
    startTime: calendar.date(bySettingHour: 8, minute: 40, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 9, minute: 25, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_2", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 3,
    startTime: calendar.date(bySettingHour: 9, minute: 45, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_3", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 4,
    startTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 11, minute: 15, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_4", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 5,
    startTime: calendar.date(bySettingHour: 11, minute: 45, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 12, minute: 30, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_5", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 6,
    startTime: calendar.date(bySettingHour: 12, minute: 30, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 13, minute: 15, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_6", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 7,
    startTime: calendar.date(bySettingHour: 13, minute: 25, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 14, minute: 10, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_7", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 8,
    startTime: calendar.date(bySettingHour: 14, minute: 10, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 14, minute: 55, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_8", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 9,
    startTime: calendar.date(bySettingHour: 15, minute: 5, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 15, minute: 50, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_9", bundle: .pittariTimerKit, comment: "")),
  SchoolPeriod(number: 10,
    startTime: calendar.date(bySettingHour: 15, minute: 50, second: 0, of: today)!,
    endTime: calendar.date(bySettingHour: 16, minute: 35, second: 0, of: today)!,
               subject: NSLocalizedString("default_schedule_period_10", bundle: .pittariTimerKit, comment: ""))
 ]
