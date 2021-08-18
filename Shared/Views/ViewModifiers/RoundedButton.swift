//
//  BlueButton.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 16.8.2021.
//

import SwiftUI

struct RoundedButton: ButtonStyle {
    
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(isActive ? Color.red.opacity(0.5) : Color.gray.opacity(0.5))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
