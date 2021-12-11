//
//  LearnQuestionsView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 03/10/2021.
//

import SwiftUI

struct LearnQuestionsView: View {
    @StateObject private var progress = LearnProgress()
    @EnvironmentObject private var settings: LearnSettings

    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var isFinished = false

    private var timerText: some View {
        Text(progress.timeRemaining.formatted(.countdownTimer))
            .foregroundColor(progress.timeRemaining <= 10 ? .red : .primary)
            .onReceive(timer, perform: updateTimer)
    }

    private var progressInfo: some View {
        ZStack(alignment: .topTrailing) {
            ProgressView(value: progress.progressValue, total: Double(settings.numberOfQuestions)) {
                HStack {
                    Text("Question \(progress.questionNumber)")
                        .fontWeight(.medium)

                    Spacer()

                    if settings.useTimer {
                        timerText
                    }
                }
            } currentValueLabel: {
                if settings.showsAnswerAfterQuestion {
                    Text("Score: **\(progress.score)**")
                }
            }
            .animation(.default, value: progress.progressValue)
        }
    }

    @ViewBuilder private var question: some View {
        switch settings.style {
        case .flagToName:
            FlagToNameQuestionView()
        case .nameToFlag:
            NameToFlagQuestionView()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                progressInfo

                Spacer()

                question
                    .multilineTextAlignment(.center)
                    .redacted(when: scenePhase != .active)

                Spacer()

                LearnQuestionsToolbar(isFinished: $isFinished, dismissAction: dismiss)
            }
            .navigationBarHidden(true)
            .padding()
        }
        .environmentObject(progress)
        .onChange(of: isFinished) {
            if $0 { timer.connect().cancel() }
        }
        .onAppear(perform: setup)
    }

    private func setup() {
        progress.setup(settings: settings)

        if settings.useTimer {
            progress.timeRemaining = settings.timerDuration * 60
            _ = timer.connect()
        }
    }

    private func updateTimer(_: Date) {
        guard scenePhase == .active else { return }

        if progress.timeRemaining > 0 {
            progress.timeRemaining -= 1
        } else {
            isFinished = true
        }
    }
}

struct LearnQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        LearnQuestionsView()
            .environmentObject(LearnSettings())
    }
}
