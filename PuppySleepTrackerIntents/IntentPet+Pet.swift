//
//  IntentPet+Pet.swift
//  PuppySleepTrackerIntents
//
//  Created by Luca Kaufmann on 22.8.2021.
//

import Foundation

extension IntentPet {
    convenience init(pet: Pet) {
        self.init(identifier: pet.name, display: pet.name)
        self.name = pet.name
        self.type = NSNumber(value: pet.animalType)
    }
}
