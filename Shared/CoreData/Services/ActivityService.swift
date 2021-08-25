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
    
    func getActiveActivity(pet: Pet) -> Activity? {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pet == %@ AND endDate == nil", pet)
        
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
        if let activity = getActiveActivity(pet: pet) {
            activity.endDate = Date()
        } else {
            let activity = create(type: type, date: Date())
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
    
    func activityDurationForDay(_ date: Date, type: String, pet: Pet) -> String {
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date)

        // Get today's beginning & end
        guard let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) else {
            return "Date to invalid"
        }
        
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

        // Set predicate as date being today's date
        let startFromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Activity.date))
        let startToPredicate = NSPredicate(format: "%K <= %@", #keyPath(Activity.date), dateTo as NSDate)
        let startDatePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startFromPredicate, startToPredicate])
        
        let endFromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Activity.endDate))
        let endToPredicate = NSPredicate(format: "%K <= %@", #keyPath(Activity.endDate), dateTo as NSDate)
        let endDatePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [endFromPredicate, endToPredicate])

        let datePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [startDatePredicate, endDatePredicate])
        
        let petPredicate = NSPredicate(format: "pet == %@", pet)
        
        let typePredicate = NSPredicate(format: "activityType == %@", type)
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, petPredicate, typePredicate])
        
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.predicate = compoundPredicate

        do {
            let result = try context.fetch(fetchRequest)
            
            var combinedInterval: TimeInterval = 0
            
            for activity in result {
                var startDate = activity.date
                var endDate = activity.endDate ?? Date()
                
                if startDate < dateFrom {
                    startDate = dateFrom
                }
                
                if endDate > dateTo {
                    endDate = dateTo
                }
                
                combinedInterval += endDate.timeIntervalSince(startDate)
            }
            
            return combinedInterval.stringFromTimeInterval()
            
        } catch let error as NSError {
            print("Error fetching subFavorite \(error)")
            return ""
        }
    }
}


