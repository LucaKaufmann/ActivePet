//
//  GradientBackground.swift
//  PuppySleepTrackerWidgetsExtension
//
//  Created by Luca Kaufmann on 24.8.2021.
//

import SwiftUI

struct GradientBackground: View {
    
    @Environment(\.widgetFamily) var widgetFamily
    var activity: Activity?
    
    var body: some View {
        if activity != nil {
            RadialGradient(gradient: Gradient(colors: [
                colorForActivityType(activity!.activityType, active: activity!.isActive(), colorType: .light),
                colorForActivityType(activity!.activityType, active: activity!.isActive(), colorType: .dark)
            ]), center: .bottom, startRadius: widgetFamily == .systemSmall ? 40 : 0, endRadius: 200)
        } else {
            RadialGradient(gradient: Gradient(colors: [
                colorForActivityType("sleep", active: false, colorType: .light),
                colorForActivityType("sleep", active: false, colorType: .dark)
            ]), center: .bottom, startRadius: 40, endRadius: 200)
        }
    }
}

struct GradientBackground_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackground()
    }
}
