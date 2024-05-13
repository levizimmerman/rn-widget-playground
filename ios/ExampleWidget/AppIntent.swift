//
//  AppIntent.swift
//  ExampleWidget
//
//  Created by Levi Zimmerman on 01/05/2024.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select favorite emoji"
    static var description = IntentDescription("This is an example widget.")
}
