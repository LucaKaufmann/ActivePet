//
//  BlueButton.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 16.8.2021.
//

import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color.gray.opacity(0.5))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
