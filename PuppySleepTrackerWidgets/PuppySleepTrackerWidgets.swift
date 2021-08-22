//
//  PuppySleepTrackerWidgets.swift
//  PuppySleepTrackerWidgets
//
//  Created by Luca Kaufmann on 22.8.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> ActivityEntry {
        ActivityEntry(date: Date(), configuration: SleepWidgetIntent(), activity: nil)
    }

    func getSnapshot(for configuration: SleepWidgetIntent, in context: Context, completion: @escaping (ActivityEntry) -> ()) {
        let entry = ActivityEntry(date: Date(), configuration: configuration, activity: nil)
        completion(entry)
    }

    func getTimeline(for configuration: SleepWidgetIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let context = PersistenceController.shared.container.viewContext
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let petService = PetService.init(context: context)
        let activityService = ActivityService.init(context: context)
        var activity: Activity? = nil
        
        if let activePet = petService.getActivePet() {
            if let activeActivity = activityService.getActiveActivityFor(pet: activePet, type: "sleep") {
                activity = activeActivity
            }

        }
                
        let entry = ActivityEntry(date: Date(), configuration: configuration, activity: activity)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct ActivityEntry: TimelineEntry {
    let date: Date
    let configuration: SleepWidgetIntent
    let activity: Activity?
}

struct PuppySleepTrackerWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            
            if let activity = entry.activity {
                RadialGradient(gradient: Gradient(colors: [Color("WidgetNightGradientLight"), Color("WidgetNightGradientDark")]), center: .bottom, startRadius: 50, endRadius: 250)
                VStack {
                    Text(activity.emojiForType())
                    Text("\(activity.formattedStartDate) - 💤")
                }
            } else {
                RadialGradient(gradient: Gradient(colors: [Color("WidgetDayGradientLight"), Color("WidgetDayGradientDark")]), center: .bottom, startRadius: 50, endRadius: 250)
                Text("Start sleep")
            }
        }
    }
}

@main
struct PuppySleepTrackerWidgets: Widget {
    let kind: String = "PuppySleepTrackerWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SleepWidgetIntent.self, provider: Provider()) { entry in
            PuppySleepTrackerWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Puppy Sleep Widget")
        .description("Widget tracking your pets sleep")
    }
}

struct PuppySleepTrackerWidgets_Previews: PreviewProvider {
    static var previews: some View {
        
        let activityService = ActivityService.init(context: PersistenceController.preview.container.viewContext)
        let activity = activityService.create(type: "sleep", date: Date())
        activity.endDate = Date()
        
        return PuppySleepTrackerWidgetsEntryView(entry: ActivityEntry(date: Date(), configuration: SleepWidgetIntent(), activity: activity))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
