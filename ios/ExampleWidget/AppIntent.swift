//
//  AppIntent.swift
//  ExampleWidget
//
//  Created by Levi Zimmerman on 29/04/2024.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Test", default: "😃")
    var favoriteEmoji: String
}
