//
//  WidgetViewModel.swift
//  PuppySleepTrackerWidgetsExtension
//
//  Created by Luca Kaufmann on 24.8.2021.
//

import Foundation

class WidgetViewModel: ObservableObject {
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var activity: Activity?
    @Published var pet: Pet?
    @Published var sleepDuration: String = ""
    @Published var playDuration: String = ""
    @Published var walkDuration: String = ""
    
    init(entry: ActivityEntry) {
        self.activity = entry.activity
        
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
    
    init(pet: Pet) {
        let activityService = ActivityService(context: viewContext)
        
        self.activity = activityService.getActiveActivity(pet: pet)
        
        self.sleepDuration = activityService.activityDurationForDay(Date(), type: "sleep", pet: pet)
        self.playDuration = activityService.activityDurationForDay(Date(), type: "play", pet: pet)
        self.walkDuration = activityService.activityDurationForDay(Date(), type: "walk", pet: pet)
    }
    
}
