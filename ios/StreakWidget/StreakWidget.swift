//
//  StreakWidget.swift
//  StreakWidget
//
//  Created by Levi Zimmerman on 17/04/2024.
//

import WidgetKit
import SwiftUI
import Intents

struct WidgetData: Decodable {
  var text: String
}

struct Provider: AppIntentTimelineProvider {
  typealias Entry = SimpleEntry
  typealias Intent = ConfigurationAppIntent
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
  }
  
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: configuration)
  }
  
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
    let userDefaults = UserDefaults.init(suiteName: "group.streak")

    if userDefaults != nil {
      let entryDate = Date()
      if let savedDate = userDefaults!.value(forKey: "widgetKey") as? String {
        let decoder = JSONDecoder()
        let data = savedDate.data(using: .utf8)
        if let parsedData = try? decoder.decode(WidgetData.self, from: data!) {
          let nextRefresh = Calendar.current.date(byAdding: .second, value: 5, to: entryDate)!
//          configuration.text = parsedData.text
          let entry = SimpleEntry(date: nextRefresh, configuration: configuration)
          return Timeline(entries: [entry], policy: .atEnd)
        } else {
          print("Could not parse data")
        }
      } else {
        let nextRefresh = Calendar.current.date(byAdding: .second, value: 5, to: entryDate)!
        configuration.text = "No data set"
        let entry = SimpleEntry(date: nextRefresh, configuration: configuration)
        return Timeline(entries: [entry], policy: .atEnd)
      }
    }
    return Timeline(entries: [], policy: .atEnd)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
}

struct StreakWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
          Text(entry.configuration.text)
            .foregroundColor(Color(red: 1.00, green: 0.59, blue: 0.00))
            .font(Font.system(size: 21, weight: .bold, design: .rounded))
            .padding(.leading, -8.0)
        }
        .padding(.top, 10.0)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        Text("Best developer of the day!")
          .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
          .font(Font.system(size: 14))
          .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}


struct StreakWidget: Widget {
    let kind: String = "StreakWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StreakWidgetEntryView(entry: entry)
              .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My widget")
        .description("This is an example widget")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var firstEntry: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.text = "This is the first input"
        return intent
    }
    
    fileprivate static var secondEntry: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.text = "This is second input"
        return intent
    }
}

// Setup to preview the widget in Xcode.
#Preview(as: .systemSmall) {
  StreakWidget()
} timeline: {
  // Add a list of entries to play in the preview.
  SimpleEntry(date: .now, configuration: .firstEntry)
  SimpleEntry(date: .now, configuration: .secondEntry)
}
