//
//  PuppySleepTrackerApp.swift
//  Shared
//
//  Created by Luca Kaufmann on 11.8.2021.
//

import SwiftUI

@main
struct PuppySleepTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
