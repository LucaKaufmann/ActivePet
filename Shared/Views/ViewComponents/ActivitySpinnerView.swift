//
//  ActivitySpinnerView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 18.8.2021.
//

import SwiftUI

struct ActivitySpinnerView: View {
    let style = StrokeStyle(lineWidth: 3, lineCap: .round)
    let color1 = Color.gray
    let color2 = Color.gray.opacity(0.5)
    
    @State var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    AngularGradient(gradient: .init(colors: [color1, color2]), center: .center), style: style
                )
                .rotationEffect(Angle(degrees: animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
        }.onAppear() {
            self.animate = true
        }
    }
}

struct ActivitySpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySpinnerView()
    }
}
