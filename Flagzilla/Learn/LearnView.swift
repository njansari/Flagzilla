//
//  LearnView.swift
//  LearnView
//
//  Created by Nayan Jansari on 04/09/2021.
//

import SwiftUI

struct LearnView: View {
    @StateObject private var settings = LearnSettings()

    var body: some View {
        NavigationView {
            TabView(selection: $settings.section) {
                QuestionAnswerStyleView(settings: settings)
                    .tag(LearnSettings.Section.style)

                Text("Next")
                    .tag(LearnSettings.Section.next)
            }
            .navigationTitle("Learn")
            .tabViewStyle(.page)
            .background(.groupedBackground)
        }
        .environmentObject(settings)
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
