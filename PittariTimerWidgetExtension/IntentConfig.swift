//
//  IntentConfig.swift
//  PittariTimer
//
//  Created by Tim Bittner on 02.02.25.
//

import WidgetKit
import AppIntents

enum CornerStyle: String, CaseIterable, AppEnum {
  case stacked = "Stacked"
  case gauge = "Gauge"
  
  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Corner Style")
  static var caseDisplayRepresentations: [CornerStyle: DisplayRepresentation] = [
    .stacked: "widget_recommend_time_and_subject",
    .gauge: "widget_recommend_gauge"
  ]
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource = "Configuration"
  static var description: LocalizedStringResource = "Corner complication style"
  
  @Parameter(title: "Corner Style", default: .stacked)
  var cornerStyle: CornerStyle
}
