//
//  MediumWidgetView.swift
//  PuppySleepTrackerWidgetsExtension
//
//  Created by Luca Kaufmann on 24.8.2021.
//

import SwiftUI

struct MediumWidgetView: View {
    
    @ObservedObject var viewModel: WidgetViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Sleep:")
                    .font(.caption)
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.sleepDuration).font(.caption)
            }
            HStack {
                Text("Walk:")
                    .font(.caption)
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.walkDuration).font(.caption)
            }
            HStack {
                Text("Play:")
                    .font(.caption)
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.playDuration).font(.caption)
            }
        }
    }
}

