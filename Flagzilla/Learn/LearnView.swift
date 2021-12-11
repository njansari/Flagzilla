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

    private var startButton: some View {
        Button("Start") {
            showingLearn = true
        }
        .buttonStyle(.listRow)
        .fullScreenCover(isPresented: $showingLearn) {
            LearnQuestionsView()
                .environment(\.scenePhase, scenePhase)
        }
    }

    private var progressToolbarButton: some View {
        Button {
            showingProgress = true
        } label: {
            Label("Progress", systemImage: "chart.xyaxis.line")
        }
        .fullScreenCover(isPresented: $showingProgress, content: ChartView.init)
    }

    var body: some View {
        NavigationView {
            List {
                QuestionStyleView()
                ContinentsFilterView()
                OtherSettingsView()

                startButton
            }
            .navigationTitle("Learn")
            .toolbar { progressToolbarButton }
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
