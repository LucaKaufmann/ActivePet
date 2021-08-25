//
//  Persistence.swift
//  Shared
//
//  Created by Luca Kaufmann on 11.8.2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let pet = Pet(context: viewContext)
        pet.name = "Zelda"
        pet.animalType = 0
        pet.active = true
        
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.minute = -1*Int.random(in: 0...59)
        dateComponent.hour = -1*Int.random(in: 0...6)
        
        let activity1 = Activity(context: viewContext)
        activity1.activityType = "sleep"
        activity1.date = calendar.date(byAdding: dateComponent, to: Date()) ?? Date()
        activity1.pet = pet
        
        dateComponent.minute = -1*Int.random(in: 0...59)
        dateComponent.hour = -1*Int.random(in: 0...1)
        
        let activity2 = Activity(context: viewContext)
        activity2.activityType = "play"
        activity2.date = calendar.date(byAdding: dateComponent, to: Date()) ?? Date()
        activity2.endDate = Date()
        activity2.pet = pet
        
        dateComponent.minute = -1*Int.random(in: 0...59)
        dateComponent.hour = -1*Int.random(in: 0...2)
        
        let activity3 = Activity(context: viewContext)
        activity3.activityType = "walk"
        activity3.date = calendar.date(byAdding: dateComponent, to: Date()) ?? Date()
        activity3.endDate = Date()
        activity3.pet = pet
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "PuppySleepTracker")
        
        var persistentStoreDescription = container.persistentStoreDescriptions.first
        
        if inMemory {
          persistentStoreDescription?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            persistentStoreDescription?.url = URL.storeURL(for: "group.puppysleeptracker", databaseName: "PuppySleepTracker")
        }
        
        persistentStoreDescription?.setOption(true as NSNumber, forKey: "NSMigratePersistentStoresAutomaticallyOption")
        persistentStoreDescription?.setOption(true as NSNumber, forKey: "NSInferMappingModelAutomaticallyOption")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
