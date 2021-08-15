//
//  PetSheetView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 14.8.2021.
//

import SwiftUI
import CoreData

struct PetSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: PetViewModel
    
    let context: NSManagedObjectContext
    
    init(viewModel: PetViewModel, context: NSManagedObjectContext) {
        self.viewModel = viewModel
        self.context = context
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Done") {
                    save()
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                
            }
            Form {
                Section {
                    LabelledFormView(label: "Name") {
                        TextField("Name", text: $viewModel.name)
                    }
    //            }
    //            Section {
                    Picker(selection: $viewModel.animalType, label: Text("Animal")) {
                        Text("🐶").tag(AnimalType.dog)
                        Text("🐱").tag(AnimalType.cat)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
    
    func save() {
        guard !viewModel.name.isEmpty else {
            return
        }
        let petService = PetService(context: context)
        let pet = petService.create(name: viewModel.name, type: viewModel.animalType.rawValue)
        petService.activatePet(pet)
        try? context.save()
    }
}

struct PetSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PetSheetView(viewModel: PetViewModel(), context: PersistenceController.preview.container.viewContext)
    }
}
