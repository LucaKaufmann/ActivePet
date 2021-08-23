//
//  File.swift
//  PuppySleepTracker (iOS)
//
//  Created by Luca Kaufmann on 23.8.2021.
//

import Foundation

func emojiForAnimalType(_ type: AnimalType) -> String {
    switch type {
    case .cat:
        return "🐱"
    case .dog:
        return "🐶"
    }
}
