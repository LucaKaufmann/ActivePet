//
//  ContentView.swift
//  Shared
//
//  Created by Luca Kaufmann on 11.8.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appState: AppState

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)],
        animation: .default)
    private var pets: FetchedResults<Pet>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)],
        predicate: NSPredicate(format: "active = true"),
        animation: .default)
    private var pet: FetchedResults<Pet>
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: true)],
//        animation: .default)
//    private var activities: FetchedResults<Activity>
    
    @State var showPetSheet: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if let pet = pet.first {
                        HStack {
                            Text(emojiForAnimalType(AnimalType(rawValue: Int(pet.animalType)) ?? .dog))
                            Divider()
                            Text(pet.name)
                        }
                        Button("Delete") {
                            print("Deleting pet \(pet.name)")
                            let petService = PetService(context: viewContext)
                            petService.delete(pet)
                        }.foregroundColor(.red)
                    } else {
                        Text("None selected")
                    }
                    
                }
                if let pet = pet.first {
                    Section {
                        PetActivityView(pet: pet)
                    }
                }
            }
            .navigationTitle("Pet")
            .sheet(isPresented: $showPetSheet) {
                PetSheetView(viewModel: PetViewModel(), context: viewContext)
            }
            .actionSheet(isPresented: $appState.showActionSheet) {
                ActionSheet(title: Text(pet.first?.name ?? "Pet"), message: Text(activityActive(appState.activity) ? "End \(appState.activity)?" : "Start \(appState.activity)?"), buttons: [
                                .default(Text(activityActive(appState.activity) ? "End" : "Start")) {
                                    let activityService = ActivityService(context: viewContext)
                                    activityService.toggleActivity(type: appState.activity, forPet: pet.first!)
                                },
                                .destructive(Text("Cancel")) { print("No") }
                ])
            }
            .toolbar {
                Menu("Pets") {
                    ForEach(pets) { pet in
                        Button(action: {
                            print("Activate pet \(pet.name)")
                            let petService = PetService(context: viewContext)
                            petService.activatePet(pet)
                        }, label: {
                            if pet.active { Image(systemName: "checkmark") }
                            Text(pet.name)
                        })
                    }
                    Button(action: {
                        self.showPetSheet = true
                    }) {
                        Label("Add Pet", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Pet(context: viewContext)
            newItem.name = "Zelda"

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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { pets[$0] }.forEach(viewContext.delete)

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
    
    private func emojiForAnimalType(_ type: AnimalType) -> String {
        switch type {
        case .cat:
            return "🐱"
        case .dog:
            return "🐶"
        }
    }
    
    private func activityActive(_ type: String) -> Bool {
        let activityService = ActivityService(context: viewContext)
        
        if let pet = pet.first {
            return activityService.getActiveActivityFor(pet: pet, type: type) != nil
        }
        
        return false
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
