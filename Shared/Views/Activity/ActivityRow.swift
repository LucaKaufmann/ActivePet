//
//  ActivityRow.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 15.8.2021.
//

import SwiftUI

struct ActivityRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var activity: Activity

    @State var isLinkActive = false
    @State var formatter: DateComponentsFormatter = {
          let formatter = DateComponentsFormatter()
          formatter.allowedUnits = [.hour, .minute, .second]
          formatter.unitsStyle = .abbreviated
          formatter.zeroFormattingBehavior = .pad
          return formatter
      }()
    
    var body: some View {
            HStack {
                Text(activity.emojiForType()).padding(.horizontal)
                Divider()
                NavigationLink(destination: ActivityEditView(viewModel: ActivityViewModel(activity: activity))) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(activity.formattedStartDate) - \(activity.formattedEndDate)")
                            if activity.isActive() {
                                ActivitySpinnerView().frame(width: 15, height: 15)
                            }
                        }
                        if activity.isActive() {
                            TimerView(isTimerRunning: true, startTime: activity.date)
//                            Text(formatter.string(from: interval) ?? "")
//                                .font(Font.system(size: 12, design: .monospaced))
//                                        .onReceive(timer) { _ in
//                                            if self.isTimerRunning && !activity.isFault{
//                                                interval = Date().timeIntervalSince(activity.date)
//                                            }
//                                        }
                        } else {
                            if let endDate = activity.endDate {
                                Text(formatter.string(from: endDate.timeIntervalSince(activity.date)) ?? "")
                                    .font(Font.system(size: 12, design: .monospaced))
                            }
                        }
                    }
                }
                Spacer()
//                if activity.isActive() {
//                    Divider()
//                    Button("🛑") {
//                        activity.endDate = Date()
//                        isTimerRunning.toggle()
//                        try? viewContext.save()
//                    }.padding(.horizontal)
//                } 
            }
//        .onAppear() {
//            if activity.isActive() && !isTimerRunning {
//                isTimerRunning.toggle()
//            }
//        }
    }
    
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        let petService = PetService(context: PersistenceController.preview.container.viewContext)
        
//        if let pet = petService.getEntityFor(name: "Zelda") {
//            return PetActivityView(pet: pet)
//        } else {
            let pet = petService.create(name: "Zelda", type: AnimalType.dog.rawValue)
            let activityService = ActivityService(context: PersistenceController.preview.container.viewContext)
            let activity1 = activityService.create(type: "sleep", date: Date())
            activity1.pet = pet
            let activity2 = activityService.create(type: "poop", date: Date())
            activity2.pet = pet
            activity2.endDate = Date()
            try? PersistenceController.preview.container.viewContext.save()
        return Group {
            NavigationView {
                ActivityRow(activity: activity1).previewLayout(PreviewLayout.fixed(width: 360, height: 60))
            }
            NavigationView {
                ActivityRow(activity: activity2).previewLayout(PreviewLayout.fixed(width: 360, height: 60))
            }
        }
//        }
    }
}
