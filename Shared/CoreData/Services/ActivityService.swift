//
//  ActivityService.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 15.8.2021.
//

import Foundation
import CoreData
import os.log
import Intents

struct ActivityService {
    
    let context: NSManagedObjectContext
    
    func delete(_ activity: Activity) {
        context.delete(activity)
        do {
            try context.save()
        } catch let error as NSError {
            print("Error saving pubFavorite \(error)")
        }
    }
    
    func create(type: String, date: Date) -> Activity {
        let activity = Activity(context: context)
        activity.activityType = type
        activity.date = date
        return activity
    }
    
    func getActiveActivityFor(pet: Pet, type: String) -> Activity? {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pet == %@ AND activityType == %@ AND endDate == nil", pet, type)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
            
        } catch let error as NSError {
            print("Error fetching subFavorite \(error)")
            return nil
        }
    }
    
    func getActiveActivity(type: String) -> Activity? {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "activityType == %@ AND endDate == nil", type)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
            
        } catch let error as NSError {
            print("Error fetching subFavorite \(error)")
            os_log("Error fetching subFavorite \(error.localizedDescription)")
            return nil
        }
    }
    
    func toggleActivity(type: String, forPet pet: Pet) {
        if let activity = getActiveActivityFor(pet: pet, type: type) {
            activity.endDate = Date()
        } else {
            let activity = create(type: "sleep", date: Date())
            activity.pet = pet
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error saving pubFavorite \(error)")
        }
        
        let intent = SleepWidgetIntent()
        let intentPet = IntentPet(identifier: pet.name, display: pet.name)
        intentPet.name = pet.name
        intent.pet = intentPet
        let interaction = INInteraction(intent: intent, response: nil)

        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.description)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
    }
    
    func endActivity(type: String, forPet pet: Pet) {
        
    }
}


