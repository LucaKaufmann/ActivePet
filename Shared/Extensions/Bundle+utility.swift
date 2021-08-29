//
//  Bundle+utility.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 29.8.2021.
//

import Foundation

extension Bundle {
  var versionNumber: String? {
    return infoDictionary?["CFBundleShortVersionString"] as? String
  }
  var buildNumber: String? {
    return infoDictionary?["CFBundleVersion"] as? String
  }
}
