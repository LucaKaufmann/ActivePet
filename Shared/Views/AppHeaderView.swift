//
//  AppHeaderView.swift
//  PuppySleepTracker
//
//  Created by Luca Kaufmann on 29.8.2021.

import SwiftUI

struct AppHeaderView: View {
    var body: some View {
        HStack {
            Image("Icon")
                .resizable()
                .frame(width: 75, height: 75)
                .cornerRadius(15)
                .padding(.horizontal)
            VStack(alignment: .leading) {
                Button(action: {
                    if let url = URL(string: "https://twitter.com/_codable") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("ActivePet").fontWeight(.bold)
                        .foregroundColor(Color("PlayActiveGradientLight"))
                }

                Text("Version \(Bundle.main.versionNumber ?? "1.0.0")b\(Bundle.main.buildNumber ?? "")")
                    .font(.footnote)
                Text("By Luca Kaufmann")
                    .font(.footnote)

            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AppHeaderView()
    }
}
