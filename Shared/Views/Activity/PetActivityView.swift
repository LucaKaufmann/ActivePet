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
    var pet: Pet
    
    init(pet: Pet) {
//        self.activities = Array(activities as? Set<Activity> ?? [])
        self.pet = pet
        self.activitiesRequest = FetchRequest(entity: Activity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: true)], predicate: NSPredicate(format: "pet == %@", pet))
    }
    
    var body: some View {
        List {
            HStack {
                Button("🛏 Sleep") {
                    setActivity("sleep")
                }
                .buttonStyle(BlueButton(isActive: isSleepActive()))
                
                Button("🧸 Play") {
                    setActivity("play")
                }
                .buttonStyle(BlueButton(isActive: isPlayActive()))
                
                Button("🦮 Walk") {
                    setActivity("walk")
                }
                .buttonStyle(BlueButton(isActive: isWalkActive()))

            }.padding(.vertical)
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
    
    private func setActivity(_ type: String) {
        if let activity = activeActivityForType(type) {
            activity.endDate = Date()
        } else {
            let activityService = ActivityService(context: viewContext)
            let newActivity = activityService.create(type: type, date: Date())
            newActivity.pet = pet
        }
        
        try? viewContext.save()
    }
    
    private func isSleepActive() -> Bool {
        return activeActivityForType("sleep") != nil
    }
    
    private func isPlayActive() -> Bool {
        return activeActivityForType("play") != nil
    }
    
    private func isWalkActive() -> Bool {
        return activeActivityForType("walk") != nil
    }
    
    private func activeActivityForType(_ type: String) -> Activity? {
//        let activityService = ActivityService(context: viewContext)
//        return activityService.getActiveActivityFor(pet: pet, type: type)
//
        if let a = Array(pet.activities) as? Array<Activity> {
            return a
                .filter({ $0.activityType == type })
                .filter({ $0.isActive() })
                .first
        } else {
            return nil
        }
    }
}

struct PetActivityView_Previews: PreviewProvider {
    static var previews: some View {
        let petService = PetService(context: PersistenceController.preview.container.viewContext)
        
            let pet = petService.create(name: "Zelda", type: AnimalType.dog.rawValue)
            let activityService = ActivityService(context: PersistenceController.preview.container.viewContext)
            let activity1 = activityService.create(type: "Sleep", date: Date())
            activity1.pet = pet
            try? PersistenceController.preview.container.viewContext.save()
        return PetActivityView(pet: pet)
    }
}
