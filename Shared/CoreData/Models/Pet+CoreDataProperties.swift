//
//  Pet+CoreDataProperties.swift
//  PuppySleepTracker (iOS)
//
//  Created by Luca Kaufmann on 14.8.2021.
//
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet")
    }

    @NSManaged public var active: Bool
    @NSManaged public var animalType: Int16
    @NSManaged public var name: String
    @NSManaged public var activities: NSSet

}

// MARK: Generated accessors for activities
extension Pet {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}

extension Pet : Identifiable {

}
