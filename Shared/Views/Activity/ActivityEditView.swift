//
//  ActivityEditView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 17.8.2021.
//

import SwiftUI

struct ActivityEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        Form {
            Section {
                LabelledFormView(label: "Type") {
                    FormTextField(text: $viewModel.activityType, placeholder: "Type")
                }
                DatePicker(selection: $viewModel.date, in: ...Date(), displayedComponents: .hourAndMinute) {
                                Text("Start time")
                            }
                HStack {
                    DatePicker(selection:  Binding<Date>(get: {viewModel.endDate ?? Date()}, set: {viewModel.endDate = $0}), in: ...Date(), displayedComponents: .hourAndMinute) {
                                    Text("End time")
                                }
                    if viewModel.endDate != nil {
                        Button("Clear") {
                            viewModel.endDate = nil
                        }
                    }
                }
            }
            Section {
                Button("Delete") {
                    delete()
                }.foregroundColor(.red)
            }
            Section {
                Button("Save") {
                    save()
                }
            }
        }
    }
    
    func save() {
        guard let activity = viewModel.activity else {
            return
        }
        
        activity.date = viewModel.date
        activity.endDate = viewModel.endDate
        activity.activityType = viewModel.activityType
        
        try? viewContext.save()
    }
    
    func delete() {
        guard let activity = viewModel.activity else {
            return
        }
        
        try? viewContext.delete(activity)
    }
}

struct ActivityEditView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityEditView(viewModel: ActivityViewModel(activity: nil))
    }
}
