//
//  PetActivityView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 15.8.2021.
//

import SwiftUI

struct PetActivityView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var activitiesRequest : FetchRequest<Activity>
    var activities : FetchedResults<Activity>{activitiesRequest.wrappedValue}
    var pet: Pet
    
    var groupedActivities: [Date: [Activity]] {
        let calendar = Calendar.current
        var grouped = [Date: [Activity]]()
        for activity in activities {
            let normalizedDate = calendar.startOfDay(for: activity.date)
            if let dateActivities = grouped[normalizedDate] {
                print("Append to existing section \(activity)")
                var activitiesForDay = dateActivities
                activitiesForDay.append(activity)
                
                grouped[normalizedDate] = activitiesForDay.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
            } else {
                print("Create new section for \(activity)")
                grouped[normalizedDate] = [activity]
            }
        }
        
        return grouped
    }
    
    var headers: [Date] {
            groupedActivities.map({ $0.key }).sorted(by: { $0.compare($1) == .orderedDescending })
        }
    
    init(pet: Pet) {
        self.pet = pet
        self.activitiesRequest = FetchRequest(entity: Activity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: false)], predicate: NSPredicate(format: "pet == %@", pet))
    }
    
    var body: some View {
        List {
            HStack {
                Button("🛏 Sleep") {
                    setActivity("sleep")
                }
                .buttonStyle(RoundedButton(isActive: isSleepActive()))
                
                Button("🧸 Play") {
                    setActivity("play")
                }
                .buttonStyle(RoundedButton(isActive: isPlayActive()))
                
                Button("🦮 Walk") {
                    setActivity("walk")
                }
                .buttonStyle(RoundedButton(isActive: isWalkActive()))

            }.padding(.vertical)
            
            ForEach(headers, id: \.self) { header in
                Section(header: PetActivityViewSectionHeader(viewContext: viewContext, date: header, pet: pet)) {
                    ForEach(groupedActivities[header]!) { activity in
                        ActivityRow(activity: activity)
                    }
                }
            }
//            .onDelete(perform: { indexSet in
//                deleteItems(offsets: indexSet)
//            })
            
//            ForEach(activities){ activity in
//                ActivityRow(activity: activity)
//            }.onDelete(perform: { indexSet in
//                deleteItems(offsets: indexSet)
//            })
        }
    }
    
    private func deleteItems(offsets: IndexSet) {

        withAnimation {
            viewContext.perform {
                print("IndexSet to delete \(offsets)")
//                for row in offsets {
//
//                    if let activitiesToDelete = groupedActivities[headers[row]] {
//    //                    offsets.map { activities[$0] }.forEach(viewContext.delete)
//                        activitiesToDelete.forEach(viewContext.delete)
//
//                        do {
//                            try viewContext.save()
//                        } catch {
//                            // Replace this implementation with code to handle the error appropriately.
//                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                            let nsError = error as NSError
//                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                        }
//                    }
//                }
                

                
            }
        }
    }
    
    private func setActivity(_ type: String) {
        let activityService = ActivityService(context: viewContext)
        activityService.toggleActivity(type: type, forPet: pet)
        
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
    
//    private func groupedActivities() -> [Date: [Activity]] {
//        let calendar = Calendar.current
//        var grouped = [Date: [Activity]]()
//        for activity in activities {
//            let normalizedDate = calendar.startOfDay(for: activity.date)
//            if let dateActivities = grouped[normalizedDate] {
//                print("Append to existing section \(activity)")
//                var activitiesForDay = dateActivities
//                activitiesForDay.append(activity)
//                activitiesForDay.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
//
//                grouped[normalizedDate] = activitiesForDay
//            } else {
//                print("Create new section for \(activity)")
//                grouped[normalizedDate] = [activity]
//            }
//        }
//
//        return grouped
//    }
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
