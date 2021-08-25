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
        let persistenceController = PersistenceController.preview
        var activity: Activity?
        let intent = SleepWidgetIntent()
        let petService = PetService(context: persistenceController.container.viewContext)
        if let pet = petService.getActivePet() {
            intent.pet = IntentPet(pet: pet)
            let activityService = ActivityService(context: persistenceController.container.viewContext)
            activity = activityService.getActiveActivity(pet: pet)
        }
        return ActivityEntry(date: Date(), configuration: intent, activity: activity)
    }

    func getSnapshot(for configuration: SleepWidgetIntent, in context: Context, completion: @escaping (ActivityEntry) -> ()) {
        let persistenceController = PersistenceController.preview
        var activity: Activity?
        let intent = SleepWidgetIntent()
        let petService = PetService(context: persistenceController.container.viewContext)
        if let pet = petService.getActivePet() {
            intent.pet = IntentPet(pet: pet)
            let activityService = ActivityService(context: persistenceController.container.viewContext)
            activity = activityService.getActiveActivity(pet: pet)
        }
        let entry = ActivityEntry(date: Date(), configuration: intent, activity: activity)
        
        completion(entry)
    }

    func getTimeline(for configuration: SleepWidgetIntent, in context: Context, completion: @escaping (Timeline<ActivityEntry>) -> ()) {
        let context = PersistenceController.shared.container.viewContext
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let petService = PetService.init(context: context)
        let activityService = ActivityService.init(context: context)
        var activity: Activity? = nil
        var pet: Pet?
        
        if let intentPet = configuration.pet {
            pet = petService.getEntityFor(name: intentPet.name ?? "" )
        } else {
            pet = petService.getActivePet()
        }
        
        if let p = pet {
            if let activeActivity = activityService.getActiveActivity(pet: p) {
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
    
    @Environment(\.widgetFamily) var widgetFamily
    @ObservedObject var viewModel: WidgetViewModel
    var entry: Provider.Entry
    
    init(entry: ActivityEntry) {
        self.entry = entry
        self.viewModel = WidgetViewModel(entry: entry)
    }

    var body: some View {
        ZStack {
            if let activity = entry.activity {
                GradientBackground(activity: activity)
                HStack {
                    SmallWidgetView(viewModel: viewModel)
                    if widgetFamily != .systemSmall {
                        Divider()
                        MediumWidgetView(viewModel: viewModel)
                        .frame(width: 125)
                        .padding(.trailing)
                        Spacer()
                    }
                }
            } else {
                GradientBackground()
                HStack {
                    SmallWidgetView(viewModel: viewModel)
                    if widgetFamily != .systemSmall {
                        Divider()
                        MediumWidgetView(viewModel: viewModel)
                        .frame(width: 125)
                        .padding(.trailing)
                        Spacer()
                    }
                }
            }
        }.widgetURL(URL(string: "puppywidget://\(entry.configuration.pet?.name ?? "")"))
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
