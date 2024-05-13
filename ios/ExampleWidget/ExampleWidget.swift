//
//  ExampleWidget.swift
//  ExampleWidget
//
//  Created by Levi Zimmerman on 01/05/2024.
//

import WidgetKit
import SwiftUI

struct WidgetData: Decodable {
  var favoriteEmoji: String
}

struct UserDefaultsConfig {
  static var suiteName = "group.example"
  static var key = "widgetKey"
  static var defaultValue = "🤷‍♀️"
}

func getFavoriteEmoji () -> String {
  // Cannot init the UserDefault suiteName, return default value
  guard
    let userDefaults = UserDefaults.init(suiteName: UserDefaultsConfig.suiteName),
    let savedData = userDefaults.value(forKey: UserDefaultsConfig.key) as? String
  else {
    return UserDefaultsConfig.defaultValue
  }

  let decoder = JSONDecoder()
  let data = savedData.data(using: .utf8)
  
  // Return the stored emoji
  if let parsedData = try? decoder.decode(WidgetData.self, from: data!) {
    return parsedData.favoriteEmoji
  }
  
  // Cannot decode saved data, return default value
  return UserDefaultsConfig.defaultValue
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
      let configuration = ConfigurationAppIntent()
      return SimpleEntry(date: Date(), configuration: configuration, favoriteEmoji: "🤷‍♀️")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
      let configuration = ConfigurationAppIntent()
      return SimpleEntry(date: Date(), configuration: configuration, favoriteEmoji: "📸")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
      var entries: [SimpleEntry] = []
      let currentDate = Date()
      // Create a simple timeline with only 1 entry that will check in 1 hour
      let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration, favoriteEmoji: getFavoriteEmoji())
      
      entries.append(entry)
      
      return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let favoriteEmoji: String
}

struct ExampleWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.favoriteEmoji)
        }
    }
}

struct ExampleWidget: Widget {
    let kind: String = "ExampleWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ExampleWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
