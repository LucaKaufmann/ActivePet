//
//  ActivityService.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 15.8.2021.
//

import Foundation
import CoreData
import os.log

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
}


