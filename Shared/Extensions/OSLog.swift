//
//  OSLog.swift
//  PuppySleepTracker (iOS)
//
//  Created by Luca Kaufmann on 22.8.2021.
//

import os.log
import Foundation

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let widget = OSLog(subsystem: subsystem, category: "widget")
}
