//
//  SmallWidgetView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 23.8.2021.
//

import SwiftUI

struct SmallWidgetView: View {
    
    var entry: ActivityEntry
    var widgetActivity: Activity?
    
    var body: some View {
        VStack {
            if let activity = widgetActivity {
                HStack(spacing: 16)  {
                    Text(activity.emojiForType())
                    Text(entry.configuration.pet?.name ?? "")
                }
                Divider()
                HStack(spacing: 16) {
                    Text("💤")
                    Text("\(activity.formattedStartDate)")
                }
            } else {
                HStack {
                    Text(emojiForAnimalType(AnimalType(rawValue: Int(truncating: entry.configuration.pet?.type ?? 0)) ?? .dog))
                    Text(entry.configuration.pet?.name ?? "")
                }
                Divider()
                HStack(spacing: 8) {
                    Text("💤")
                    Text("Tap to nap!").font(.caption)
                }
            }
        }.padding()
    }
}
