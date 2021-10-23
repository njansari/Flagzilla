//
//  LearnView.swift
//  LearnView
//
//  Created by Nayan Jansari on 04/09/2021.
//

import SwiftUI

struct LearnView: View {
    @StateObject private var settings = LearnSettings()

    @State private var showingStats = false
    @State private var showingLearn = false

    var body: some View {
        NavigationView {
            List {
                QuestionStyleView()

                ContinentsFilterView()

                OtherSettingsView()

                Button("Start") {
                    showingLearn = true
                }
                .buttonStyle(.listRow)
                .fullScreenCover(isPresented: $showingLearn, content: LearnQuestionsView.init)
            }
            .navigationTitle("Learn")
            .toolbar {
                Button {
                    showingStats = true
                } label: {
                    Label("Statistics", systemImage: "chart.xyaxis.line")
                }
                .fullScreenCover(isPresented: $showingStats, content: ChartView.init)
            }
        }
        .environmentObject(settings)
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
            .environmentObject(LearnSettings())
    }
}
