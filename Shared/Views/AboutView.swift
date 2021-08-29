//
//  AboutView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 29.8.2021.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                
            }
            Form {
//                Section {
                    AppHeaderView()
//                }
                Section(header: Text("Links")) {
                    Button("Follow Me", action: {
                        if let url = URL(string: "https://twitter.com/_codable") {
                            UIApplication.shared.open(url)
                        }
                    })
                    Button("Puppy pictures!", action: {
                        if let url = URL(string: "https://instagram.com/zeldacloudprincess") {
                            UIApplication.shared.open(url)
                        }
                    })
                }

//                Section(header: Text("Thanks to")) {
//                    Button("CocoaMQTT", action: {
//                        if let url = URL(string: "https://github.com/emqx/CocoaMQTT") {
//                            UIApplication.shared.open(url)
//                        }
//                    })
//                    Button("HighlighterSwift", action: {
//                        if let url = URL(string: "https://github.com/smittytone/HighlighterSwift") {
//                            UIApplication.shared.open(url)
//                        }
//                    })
//                    Button("SwiftyJSON", action: {
//                        if let url = URL(string: "https://github.com/SwiftyJSON/SwiftyJSON") {
//                            UIApplication.shared.open(url)
//                        }
//                    })
//                    Button("TPInAppReceipt", action: {
//                        if let url = URL(string: "https://github.com/tikhop/TPInAppReceipt") {
//                            UIApplication.shared.open(url)
//                        }
//                    })
//                    Button("MQTTAnalyzer", action: {
//                        if let url = URL(string: "https://github.com/philipparndt/mqtt-analyzer") {
//                            UIApplication.shared.open(url)
//                        }
//                    })
//                }
                Section(header: Text("Story time")) {
                    Text("I came up with the idea for this app after getting my fluff ball pup Zelda. She had a rough time finding her sleep schedule and I noticed that sticking to a similar schedule every day improved her nights sleep dramatically. A large part of this app was written at 4am with a puppy chewing on my computer charger, chair leg, slippers... I hope other new (or old) pet parents find it useful and I'm always happy to hear any feedback or feature requests!").font(.body)
                    Image("zelda")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .navigationBarTitle("About", displayMode: .inline)
//            .navigationBarColor(UIColor(named: "purple"))

        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
