//
//  SmallWidgetView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 23.8.2021.
//

import SwiftUI

struct SmallWidgetView: View {
    
    @ObservedObject var viewModel: WidgetViewModel
    
    var body: some View {
        VStack {
            if let pet = viewModel.pet {
                if let activity = viewModel.activity {
                    HStack(spacing: 16)  {
                        Text(emojiForAnimalType(AnimalType(rawValue: Int(pet.animalType)) ?? .dog))
                        Text(viewModel.pet?.name ?? "")
                    }
                    Divider()
                    HStack(spacing: 16) {
                        Text(activity.emojiForType())
                        Text("\(activity.formattedStartDate)")
                    }
                } else {

                        HStack {
                                Text(emojiForAnimalType(AnimalType(rawValue: Int(pet.animalType)) ?? .dog))
                                Text(pet.name)
                        }
                        Divider()
                        HStack(spacing: 8) {
                            Text("Start a new activity").font(.caption)
                        }

                }
            } else {
                Text("Select a pet").font(.title)
            }
        }.padding()
    }
}
