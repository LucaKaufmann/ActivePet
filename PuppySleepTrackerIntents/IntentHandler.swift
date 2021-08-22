//
//  IntentHandler.swift
//  PuppySleepTrackerIntents
//
//  Created by Luca Kaufmann on 22.8.2021.
//

import Intents

class IntentHandler: INExtension, SleepWidgetIntentHandling {
    
    func resolvePet(for intent: SleepWidgetIntent, with completion: @escaping (IntentPetResolutionResult) -> Void) {
        let context = PersistenceController.shared.container.viewContext
        let petService = PetService(context: context)
        if let intentPet = intent.pet {
            if intentPet.name != nil {
                completion(IntentPetResolutionResult.success(with: intentPet))
                return
            }
            
            if let intentPetName = intentPet.name {
                if let pet = petService.getEntityFor(name: intentPetName) {
                    completion(IntentPetResolutionResult.success(with: IntentPet(pet: pet)))
                    return
                }
            }
        }
        
        completion(IntentPetResolutionResult.unsupported())
        return
    }
    
    func providePetOptionsCollection(for intent: SleepWidgetIntent, with completion: @escaping (INObjectCollection<IntentPet>?, Error?) -> Void) {
//        let context = PersistenceController.shared.container.viewContext
//        let petService = PetService(context: context)
//        let pets = petService.getPets()
        
        let objectCollection = INObjectCollection(sections: [
            INObjectSection(title: "Pets", items: [IntentPet(identifier: "Zelda", display: "Zelda")])
//            INObjectSection(title: "Pets", items: pets.map { IntentPet(pet: $0) })
        ])
        completion(objectCollection, nil)
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
