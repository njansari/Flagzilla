//
//  LearnQuestionsView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 03/10/2021.
//

import SwiftUI

extension View {
    @ViewBuilder func redacted(if condition: Bool) -> some View {
        if condition {
            redacted(reason: .placeholder)
        } else {
            unredacted()
        }
    }
}

struct LearnQuestionsView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var progress = LearnProgress()

    @EnvironmentObject private var settings: LearnSettings

    @Environment(\.scenePhase) private var scenePhase

    @State private var showingDismissConfirmation = false
    @State private var isFinished = false

    let timer = Timer.publish(every: 1, on: .main, in: .common)

    var timerText: some View {
        Text(progress.timeRemaining.formatted(.countdownTimer))
            .foregroundColor(progress.timeRemaining <= 10 ? .red : .primary)
            .onReceive(timer) { _ in
                guard scenePhase == .active else { return }

                if progress.timeRemaining > 0 {
                    progress.timeRemaining -= 1
                } else {
                    isFinished = true
                }
            }
    }

    var progressInfo: some View {
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

    @ViewBuilder var question: some View {
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
                    .redacted(if: scenePhase != .active)

                Spacer()

                toolbar
            }
            .navigationBarHidden(true)
            .padding()
        }
        .environmentObject(progress)
        .onAppear {
            progress.setup(settings: settings)

            if settings.useTimer {
                progress.timeRemaining = settings.timerDuration * 60
                _ = timer.connect()
            }
        }
        .onChange(of: isFinished) {
            if $0 {
                timer.connect().cancel()
            }
        }
    }
}

extension LearnQuestionsView {
    var backButton: some View {
        Button {
            progress.back()
        } label: {
            Image(systemName: "chevron.left")
                .imageScale(.large)

            Text("Back")
                .frame(alignment: .leading)
        }
        .foregroundColor(.accentColor)
    }

    var endButton: some View {
        Button(role: .destructive) {
            showingDismissConfirmation = true
        } label: {
            Text("End")
                .frame(maxWidth: 50)
        }
        .foregroundColor(.red)
        .confirmationDialog("Are you sure you want to end?", isPresented: $showingDismissConfirmation) {
            Button("End Now", role: .destructive, action: dismiss.callAsFunction)
        } message: {
            Text("Ending now will delete any progress made.")
        }
    }

    var nextButton: some View {
        Button {
            progress.next()
        } label: {
            Text("Next")
                .frame(alignment: .trailing)

            Image(systemName: "chevron.right")
                .imageScale(.large)
        }
        .foregroundColor(.accentColor)
    }

    var finishButton: some View {
        NavigationLink(isActive: $isFinished) {
            LearnQuestionsSummary(dismissAction: dismiss)
        } label: {
            Text("Finish")
                .frame(alignment: .trailing)
        }
        .buttonStyle(.borderedProminent)
        .tint(.accentColor)
    }

    var toolbar: some View {
        HStack {
            backButton
                .opacity(settings.showsAnswerAfterQuestion || progress.questionNumber == 1 ? 0 : 1)

            Spacer()

            endButton

            Spacer()

            ZStack {
                if progress.questionNumber < progress.questions.count {
                    nextButton
                }

                finishButton
                    .opacity(progress.questionNumber >= progress.questions.count ? 1 : 0)
            }
            .opacity(progress.currentQuestion.selectedAnswer == nil ? 0 : 1)
        }
        .font(.title3.weight(.medium))
        .buttonStyle(.bordered)
        .tint(Color(uiColor: .systemBackground))
    }
}

struct LearnQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        LearnQuestionsView()
            .environmentObject(LearnSettings())
    }
}