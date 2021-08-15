//
//  PetViewModel.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 14.8.2021.
//

import Foundation

enum AnimalType: Int {
    case dog, cat
}

class PetViewModel: ObservableObject {
    @Published var pet: Pet? {
        didSet {
            if let p = pet {
                name = p.name
                active = p.active
                
                if let type = AnimalType(rawValue: Int(p.animalType)) {
                    animalType = type
                }
            }
        }
    }
    
    @Published var name: String = ""
    @Published var animalType: AnimalType = .dog
    @Published var active: Bool = true
    
    init(pet: Pet? = nil) {
        self.pet = pet
    }
}
