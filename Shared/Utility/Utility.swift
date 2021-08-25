//
//  File.swift
//  PuppySleepTracker (iOS)
//
//  Created by Luca Kaufmann on 23.8.2021.
//

import Foundation
import SwiftUI

func emojiForAnimalType(_ type: AnimalType) -> String {
    switch type {
    case .cat:
        return "🐱"
    case .dog:
        return "🐶"
    }
}

enum ColorType {
    case dark, light
}

func colorForActivityType(_ type: String, active: Bool, colorType: ColorType) -> Color {
    
    switch type {
    case "sleep":
        switch colorType {
        case .light:
            return active ? Color("SleepActiveGradientLight") : Color("SleepInactiveGradientLight")
        case .dark:
            return active ? Color("SleepActiveGradientDark") : Color("SleepInactiveGradientDark")
        }
    case "play":
        switch colorType {
        case .light:
            return active ? Color("PlayActiveGradientLight") : Color("SleepInactiveGradientLight")
        case .dark:
            return active ? Color("PlayActiveGradientDark") : Color("SleepInactiveGradientDark")
        }
    case "walk":
        switch colorType {
        case .light:
            return active ? Color("WalkActiveGradientLight") : Color("SleepInactiveGradientLight")
        case .dark:
            return active ? Color("WalkActiveGradientDark") : Color("SleepInactiveGradientDark")
        }
    default:
        switch colorType {
        case .light:
            return active ? Color("SleepActiveGradientLight") : Color("SleepInactiveGradientLight")
        case .dark:
            return active ? Color("SleepActiveGradientDark") : Color("SleepInactiveGradientDark")
        }
    }
    
}
