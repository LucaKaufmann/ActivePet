//
//  WidgetViewModel.swift
//  PuppySleepTrackerWidgetsExtension
//
//  Created by Luca Kaufmann on 24.8.2021.
//

import Foundation
import CoreData

class WidgetViewModel: ObservableObject {
    
    let viewContext: NSManagedObjectContext
    
    @Published var activity: Activity?
    @Published var pet: Pet?
    @Published var sleepDuration: String = ""
    @Published var playDuration: String = ""
    @Published var walkDuration: String = ""
    
    init(entry: ActivityEntry) {
        self.activity = entry.activity
        self.viewContext = entry.context
        
        let petService = PetService(context: viewContext)
        if let intentPet = entry.configuration.pet {
            self.pet = petService.getEntityFor(name: intentPet.name ?? "")
        }
        
        if let p = pet {
            let activityService = ActivityService(context: viewContext)
            self.sleepDuration = activityService.activityDurationForDay(Date(), type: "sleep", pet: p)
            self.playDuration = activityService.activityDurationForDay(Date(), type: "play", pet: p)
            self.walkDuration = activityService.activityDurationForDay(Date(), type: "walk", pet: p)
        }
    }
    
}
