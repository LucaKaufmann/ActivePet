//
//  PuppySleepTrackerApp.swift
//  Shared
//
//  Created by Luca Kaufmann on 11.8.2021.
//

import SwiftUI
import CoreData
import WidgetKit

@main
struct PuppySleepTrackerApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                WidgetCenter.shared.reloadAllTimelines()

                if !isDBMigrated() {
                    migrateCoreData()
                }
            case .background:
                print("App background")
            case .inactive:
                print("App inactive")
            @unknown default:
                break
            }
        }
    }
    
    func isDBMigrated() -> Bool {
        return UserDefaults.standard.bool(forKey: "app.puppysleeptracker.migrated")
    }
    
    func migrateCoreData() {
        let oldStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("PuppySleepTracker.sqlite")
        let newStoreURL = AppGroup.group.containerURL.appendingPathComponent("PuppySleepTracker.sqlite")
        
        let coordinator = persistenceController.container.persistentStoreCoordinator
        
        print("Migrate core data")
        
        if let oldStore = coordinator.persistentStore(for: oldStoreURL) {
            do {
                try coordinator.migratePersistentStore(oldStore, to: newStoreURL, withType: NSSQLiteStoreType)
                UserDefaults.standard.setValue(true, forKey: "app.puppysleeptracker.migrated"
                )// Marking as DB is migrated successfully.
            } catch {
                print(error)
            }
        }
    }
}

enum AppGroup: String {
  case group = "group.puppysleeptracker"

  public var containerURL: URL {
    switch self {
    case .group:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
