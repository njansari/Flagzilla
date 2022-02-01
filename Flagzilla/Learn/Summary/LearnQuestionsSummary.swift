//
//  LearnQuestionsSummary.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 05/10/2021.
//

import SwiftUI

typealias EnumeratedQuestion = (offset: Int, element: Question)

struct LearnQuestionsSummary: View {
    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    @State private var selectedQuestionCategory: QuestionSummaryCategory = .correct

    let dismissAction: DismissAction

    private var questionBreakdown: LearnProgress.QuestionBreakdown {
        progress.percentageBreakdown
    }

    private var scoreText: some View {
        VStack {
            Text(questionBreakdown.correct, format: .percent.rounded(rule: .down).precision(.fractionLength(0)))
                .font(.largeTitle.bold())

            Text("\(progress.score)/\(settings.numberOfQuestions)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var questionRateLabel: String {
        let formattedRate = progress.questionRate.formatted(.number.precision(.significantDigits(2)))
        return "\(formattedRate) sec"
    }

    private var statsPagingView: some View {
        TabView {
            scoreText

            if settings.useTimer {
                VStack {
                    Text(questionRateLabel)
                        .fontWeight(.medium)

                    Text("per question")
                        .font(.caption)
                }
                .frame(maxWidth: 100)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: 120, height: 120)
    }

    private var scoreHeader: some View {
        VStack {
            ZStack {
                statsPagingView

                Group {
                    TrimmedProgressCircle(for: .correct, selectedCategory: $selectedQuestionCategory)
                    TrimmedProgressCircle(for: .incorrect, selectedCategory: $selectedQuestionCategory)
                    TrimmedProgressCircle(for: .unanswered, selectedCategory: $selectedQuestionCategory)
                }
                .rotationEffect(.radians(.pi / -2))
                .frame(maxWidth: 150, maxHeight: 150)
                .animation(.easeInOut, value: selectedQuestionCategory)
                .accessibilityHidden(true)
            }
            .multilineTextAlignment(.center)
            .padding(.vertical, 25)

            QuestionsSummarySegmentedControl(questionCategory: $selectedQuestionCategory)
        }
        .padding(.horizontal)
    }

    private var questionSummaryList: some View {
        switch selectedQuestionCategory {
        case .correct:
            return QuestionSummaryList(for: .correct, questionStyle: settings.style)
        case .incorrect:
            return QuestionSummaryList(for: .incorrect, questionStyle: settings.style)
        case .unanswered:
            return QuestionSummaryList(for: .unanswered, questionStyle: settings.style)
        }
    }

    private var doneToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Done", action: dismissAction.callAsFunction)
        }
    }

    var body: some View {
        VStack {
            scoreHeader

            Spacer()

            questionSummaryList
                .navigationTitle("Summary")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar { doneToolbarButton }
        }
        .background(.groupedBackground)
        .task { await saveProgress() }
    }

    private func saveProgress() async {
        var loadedProgress: [SavedProgress] = []
        await loadedProgress.loadSaved()

        let progressPerContinent = settings.continents.map { continent -> SavedProgress.ProgressPerContinent in
            let score = progress.correctQuestions.filter { $0.element.answer.continents.contains(continent) }.count
            let numQuestions = progress.questions.filter { $0.answer.continents.contains(continent) }.count

            return SavedProgress.ProgressPerContinent(continent, score: score, numberOfQuestions: numQuestions)
        }

        var timing: SavedProgress.Timing? = nil

        if settings.useTimer {
            let duration = settings.timerDuration * 60
            timing = .init(elapsed: progress.timeElapsed, total: duration, rate: progress.questionRate)
        }

        let newProgress = SavedProgress(progressPerContinent: progressPerContinent, timing: timing)

        loadedProgress.append(newProgress)
        loadedProgress.save()
    }
}

struct LearnQuestionsSummary_Previews: PreviewProvider {
    @Environment(\.dismiss) static private var dismiss

    static var previews: some View {
        NavigationView {
            LearnQuestionsSummary(dismissAction: dismiss)
        }
        .environmentObject(LearnSettings())
        .environmentObject(LearnProgress())
    }
}
