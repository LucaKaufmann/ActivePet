//
//  TimerView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 18.8.2021.
//

import SwiftUI

struct TimerView: View {
    
    @State var isTimerRunning = false
    @State var startTime =  Date()
    @State private var interval = TimeInterval()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var formatter: DateComponentsFormatter = {
          let formatter = DateComponentsFormatter()
          formatter.allowedUnits = [.hour, .minute, .second]
          formatter.unitsStyle = .abbreviated
          formatter.zeroFormattingBehavior = .pad
          return formatter
      }()
    
    var body: some View {
        Text(formatter.string(from: interval) ?? "")
            .font(Font.system(size: 12, design: .monospaced))
                    .onReceive(timer) { _ in
                        if self.isTimerRunning {
                            interval = Date().timeIntervalSince(startTime)
                        }
                    }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
