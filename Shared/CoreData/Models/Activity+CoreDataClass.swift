//
//  Activity+CoreDataClass.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 11.8.2021.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {
    
    var formattedStartDate: String {
        guard !self.isFault else {
            return ""
        }
        return formattedDate(self.date)
    }
    
    var formattedEndDate: String {
        guard let date = self.endDate else {
            return ""
        }
        return formattedDate(date)
    }
    
    var activityDuration: String {
        guard let endDate = self.endDate else {
            return ""
        }
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: self.date, to: endDate)
        var duration = ""
        if let hours = diffComponents.hour, hours > 0 {
            duration += "\(hours)h "
        }
        if let minutes = diffComponents.minute, minutes > 0 {
            duration += "\(minutes)min"
        }
        if let seconds = diffComponents.second, seconds > 0 {
            duration += "\(seconds)s"
        }
        return duration
    }
    
    func isActive() -> Bool {
        return self.endDate == nil
    }
    
    func emojiForType() -> String {
        switch self.activityType {
        case "sleep":
            return "🛏"
        case "poop":
            return "💩"
        case "play":
            return "🧸"
        case "walk":
            return "🦮"
        default:
            return "🐱"
        }
    }
    
//    func formattedStartDate() -> String {
//        let calendar = Calendar.current
//
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = calendar.isDateInToday(self.date) ? "HH:mm" : "ddd HH:mm"
//
//        return dateFormatter.string(from: self.date)
//    }
//
//    func formattedEndDate() -> String {
//        return dateFormatter.string(from: self.endDate)
//    }
    
    private func formattedDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = calendar.isDateInToday(date) ? "HH:mm" : "E HH:mm"
        
        return dateFormatter.string(from: date)
    }
}
