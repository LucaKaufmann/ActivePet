//
//  PetActivityViewSectionHeader.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 26.8.2021.
//

import SwiftUI
import CoreData

struct PetActivityViewSectionHeader: View {
    
    var viewContext: NSManagedObjectContext
    var date: Date
    let pet: Pet
    let activityService: ActivityService
    
    init(viewContext: NSManagedObjectContext, date: Date, pet: Pet) {
        self.viewContext = viewContext
        self.date = date
        self.pet = pet
        self.activityService = ActivityService(context: viewContext)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(date, style: .date)
            HStack {
                VStack {
                    Text(emojiForActivityType("sleep"))
                    Text(activityService.activityDurationForDay(date, type: "sleep", pet: pet)).font(.system(.footnote))
                }
                Spacer()
                Divider()
                Spacer()
                VStack {
                    Text(emojiForActivityType("play"))
                    Text(activityService.activityDurationForDay(date, type: "play", pet: pet)).font(.system(.footnote))
                }
                Spacer()
                Divider()
                Spacer()
                VStack {
                    Text(emojiForActivityType("walk"))
                    Text(activityService.activityDurationForDay(date, type: "walk", pet: pet)).font(.system(.footnote))
                }
            }
            HStack {
                Spacer()
              }
        }.padding()
    }
}

struct PetActivityViewSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let petService = PetService(context: viewContext)
        let activePet = petService.getActivePet() ?? petService.create(name: "Zelda", type: 0)
        
        return PetActivityViewSectionHeader(viewContext: viewContext, date: Date(), pet: activePet).previewLayout(PreviewLayout.fixed(width: 300, height: 60))
    }
}
