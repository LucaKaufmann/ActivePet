//
//  Activity+CoreDataProperties.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 11.8.2021.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var date: Date
    @NSManaged public var endDate: Date?
    @NSManaged public var activityType: String
    @NSManaged public var notes: String
    @NSManaged public var pet: Pet

}

extension Activity : Identifiable {

}
