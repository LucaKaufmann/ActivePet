//
//  TimeInterval+String.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 23.8.2021.
//

import Foundation

extension TimeInterval {

        func stringFromTimeInterval() -> String {

            let time = NSInteger(self)

            let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = time % 60
            let minutes = (time / 60) % 60
            let hours = (time / 3600)

            return String(format: "%0.2dh %0.2dm",hours,minutes)

        }
    }
