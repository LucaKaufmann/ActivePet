//
//  PetService.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 14.8.2021.
//

import Foundation
import CoreData
import os.log


struct PetService {
    
    let context: NSManagedObjectContext
        
    func getEntityFor(name: String) -> Pet? {
        let fetchRequest: NSFetchRequest<Pet> = Pet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = '\(name)'")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            return result.first
        } catch let error as NSError {
            print("Error fetching subFavorite \(error)")
            return nil
        }
    }
    
    func getPets() -> [Pet] {
        let fetchRequest: NSFetchRequest<Pet> = Pet.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Error fetching pets \(error)")
            os_log("Error fetching pets \(error.localizedDescription)")
            return []
        }
    }
    
    func delete(_ pet: Pet) {
        context.delete(pet)
        do {
            try context.save()
        } catch let error as NSError {
            print("Error saving pubFavorite \(error)")
        }
    }
    
    func create(name: String, type: Int) -> Pet {
        let pet = Pet(context: context)
        pet.name = name
        pet.animalType = Int16(type)
        return pet
    }
    
    func activatePet(_ pet: Pet) {
        let fetchRequest: NSFetchRequest<Pet> = Pet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "active = true")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            for pet in result {
                pet.active = false
            }
        } catch let error as NSError {
            print("Error fetching pets \(error)")
        }
        
        pet.active = true
        try? context.save()
    }
    
    func getActivePet() -> Pet? {
        let fetchRequest: NSFetchRequest<Pet> = Pet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "active = true")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            return result.first
        } catch let error as NSError {
            print("Error fetching subFavorite \(error)")
            return nil
        }
    }
}

