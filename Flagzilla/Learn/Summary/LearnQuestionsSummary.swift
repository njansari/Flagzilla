//
//  LearnQuestionsSummary.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 05/10/2021.
//

import SwiftUI

typealias EnumeratedQuestion = (offset: Int, element: Question)
typealias QuestionBreakdown = (correct: Double, incorrect: Double, unanswered: Double)

struct LearnQuestionsSummary: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    @State private var selectedQuestionCategory: QuestionSummaryCategory = .correct

    let dismissAction: DismissAction

    var percentageBreakdown: QuestionBreakdown {
        let correct = Double(correctQuestions.count) / Double(settings.numberOfQuestions)
        let incorrect = Double(incorrectQuestions.count) / Double(settings.numberOfQuestions)
        let unanswered = Double(unansweredQuestions.count) / Double(settings.numberOfQuestions)

        return (correct, incorrect, unanswered)
    }

    var correctQuestions: [EnumeratedQuestion] {
        progress.questions.enumerated().filter { $0.element.isCorrect }
    }

    var incorrectQuestions: [EnumeratedQuestion] {
        progress.questions.enumerated().filter { !$0.element.isCorrect && $0.element.isAnswered }
    }

    var unansweredQuestions: [EnumeratedQuestion] {
        progress.questions.enumerated().filter { !$0.element.isAnswered }
    }

    var correctCircle: some View {
        Circle()
            .trim(from: 0, to: percentageBreakdown.correct)
            .stroke(QuestionSummaryCategory.correct.color, lineWidth: selectedQuestionCategory == .correct ? 40 : 35)
            .onTapGesture {
                selectedQuestionCategory = .correct
            }
    }

    var incorrectCircle: some View {
        Circle()
            .trim(from: percentageBreakdown.correct, to: percentageBreakdown.correct + percentageBreakdown.incorrect)
            .stroke(QuestionSummaryCategory.incorrect.color, lineWidth: selectedQuestionCategory == .incorrect ? 40 : 35)
            .onTapGesture {
                selectedQuestionCategory = .incorrect
            }
    }

    var unansweredCircle: some View {
        Circle()
            .trim(from: percentageBreakdown.correct + percentageBreakdown.incorrect, to: 1)
            .stroke(QuestionSummaryCategory.unanswered.color, lineWidth: selectedQuestionCategory == .unanswered ? 40 : 35)
            .onTapGesture {
                selectedQuestionCategory = .unanswered
            }
    }

    var scoreText: some View {
        VStack {
            Text(percentageBreakdown.correct, format: .percent)
                .font(.largeTitle.bold())

            Text("\(progress.score)/\(settings.numberOfQuestions)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    var questionRateLabel: String {
        let formattedRate = progress.questionRate.formatted(.number.precision(.significantDigits(2)))
        return "\(formattedRate) sec"
    }

    var statsPagingView: some View {
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

    var scoreHeader: some View {
        VStack {
            ZStack {
                statsPagingView

                Group {
                    correctCircle
                    incorrectCircle
                    unansweredCircle
                }
                .rotationEffect(.radians(.pi / -2))
                .frame(width: 150, height: 150)
                .animation(.easeInOut, value: selectedQuestionCategory)
            }
            .multilineTextAlignment(.center)
            .frame(maxHeight: 220)

            QuestionsSummarySegmentedControl(questionCategory: $selectedQuestionCategory)
        }
        .padding(.horizontal)
    }

    var questionsSummaryList: some View {
        switch selectedQuestionCategory {
            case .correct:
                return QuestionSummaryList(category: .correct, questionsStyle: settings.style, questions: correctQuestions)
            case .incorrect:
                return QuestionSummaryList(category: .incorrect, questionsStyle: settings.style, questions: incorrectQuestions)
            case .unanswered:
                return QuestionSummaryList(category: .unanswered, questionsStyle: settings.style, questions: unansweredQuestions)
        }
    }

    var body: some View {
        VStack {
            scoreHeader

            Spacer()

            List {
                questionsSummaryList
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: dismissAction.callAsFunction)
                }
            }
        }
        .background(.groupedBackground)
        .task {
            await loadAndSaveProgress()
        }
    }

    func loadAndSaveProgress() async {
        var loadedProgress: [SavedProgress] = []
        await loadedProgress.loadSaved()

        let progressPerContinent = settings.continents.map { continent -> SavedProgress.ProgressPerContinent in
            let score = correctQuestions.filter { $0.element.answer.continents.contains(continent) }.count
            let numberOfQuestions = progress.questions.filter { $0.answer.continents.contains(continent) }.count

            return SavedProgress.ProgressPerContinent(continent: continent, score: score, numberOfQuestions: numberOfQuestions)
        }

        let timing: SavedProgress.Timing?

        if settings.useTimer {
            timing = .init(timeElapased: progress.timeElapsed, totalTime: settings.timerDuration * 60, questionRate: progress.questionRate)
        } else {
            timing = nil
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
