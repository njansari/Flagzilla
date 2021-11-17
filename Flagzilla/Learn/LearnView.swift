//
//  LearnView.swift
//  LearnView
//
//  Created by Nayan Jansari on 04/09/2021.
//

import SwiftUI

struct LearnView: View {
    @StateObject private var settings = LearnSettings()

    @Environment(\.scenePhase) private var scenePhase

    @State private var showingProgress = false
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
                .fullScreenCover(isPresented: $showingLearn) {
                    LearnQuestionsView()
                        .environment(\.scenePhase, scenePhase)
                }
            }
            .navigationTitle("Learn")
            .toolbar {
                Button {
                    showingProgress = true
                } label: {
                    Label("Progress", systemImage: "chart.xyaxis.line")
                }
                .fullScreenCover(isPresented: $showingProgress, content: ChartView.init)
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
