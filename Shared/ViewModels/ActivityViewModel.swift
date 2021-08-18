//
//  ActivityViewModel.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 17.8.2021.
//

import Foundation

class ActivityViewModel: ObservableObject {
    @Published var activity: Activity? {
        didSet {
            if let a = activity  {
                if !a.isFault {
                    date = a.date
                    endDate = a.endDate
                    notes = a.notes
                    activityType = a.activityType
                }
            }
        }
    }
    
    @Published var date: Date = Date()
    @Published var endDate: Date?
    @Published var notes: String = ""
    @Published var activityType: String = "sleep"
    
    init(activity: Activity? = nil) {
        self.activity = activity
    }
}
