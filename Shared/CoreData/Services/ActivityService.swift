//
//  ActivityService.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 15.8.2021.
//

import Foundation
import CoreData

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
}


