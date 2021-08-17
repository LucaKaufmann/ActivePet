//
//  PetActivityView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 15.8.2021.
//

import SwiftUI

struct PetActivityView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
//    var activities: [Activity]
    var activitiesRequest : FetchRequest<Activity>
    var activities : FetchedResults<Activity>{activitiesRequest.wrappedValue}
    
    init(predicate: NSPredicate) {
//        self.activities = Array(activities as? Set<Activity> ?? [])
        self.activitiesRequest = FetchRequest(entity: Activity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: true)], predicate: predicate)
    }
    
    var body: some View {
        List {
//            ForEach(Array(pet.activities as? Set<Activity> ?? []), id: \.self){ activity in
            ForEach(activities){ activity in
                ActivityRow(activity: activity)
            }.onDelete(perform: { indexSet in
                deleteItems(offsets: indexSet)
            })
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            viewContext.perform {
                offsets.map { activities[$0] }.forEach(viewContext.delete)

                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

struct PetActivityView_Previews: PreviewProvider {
    static var previews: some View {
        let petService = PetService(context: PersistenceController.preview.container.viewContext)
        
//        if let pet = petService.getEntityFor(name: "Zelda") {
//            return PetActivityView(pet: pet)
//        } else {
            let pet = petService.create(name: "Zelda", type: AnimalType.dog.rawValue)
            let activityService = ActivityService(context: PersistenceController.preview.container.viewContext)
            let activity1 = activityService.create(type: "Sleep", date: Date())
            activity1.pet = pet
            try? PersistenceController.preview.container.viewContext.save()
        return PetActivityView(predicate: NSPredicate(format: "pet == %@", pet))
//        }
    }
}
