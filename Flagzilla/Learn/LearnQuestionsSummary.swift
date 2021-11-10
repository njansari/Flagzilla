//
//  LearnQuestionsSummary.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 05/10/2021.
//

import SwiftUI

struct LearnQuestionsSummary: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    @State private var selectedQuestionCategory: QuestionSummaryCategory = .correct

    let dismissAction: DismissAction

    var percentageScore: Double {
        let percent = Double(progress.score) / Double(settings.numberOfQuestions)
        return (percent * 100).rounded(.down) / 100
    }

    var correctQuestions: [(offset: Int, element: Question)] {
        progress.questions.enumerated().filter { $0.element.isCorrect }
    }

    var incorrectQuestions: [(offset: Int, element: Question)] {
        progress.questions.enumerated().filter { !$0.element.isCorrect }
    }

    var scoreHeader: some View {
        VStack {
            ZStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: percentageScore)
                        .stroke(.green, lineWidth: selectedQuestionCategory == .correct ? 40 : 35)
                        .onTapGesture {
                            selectedQuestionCategory = .correct
                        }

                    Circle()
                        .trim(from: percentageScore, to: 1)
                        .stroke(.red, lineWidth: selectedQuestionCategory == .incorrect ? 40 : 35)
                        .onTapGesture {
                            selectedQuestionCategory = .incorrect
                        }
                }
                .rotationEffect(.radians(.pi / -2))
                .frame(width: 150, height: 150)
                .animation(.easeInOut, value: selectedQuestionCategory)

                VStack {
                    Text(percentageScore, format: .percent)
                        .font(.largeTitle.bold())

                    Text("\(progress.score)/\(settings.numberOfQuestions)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 220)

            QuestionsSummarySegmentedControl(questionCategory: $selectedQuestionCategory)
        }
        .padding(.horizontal)
    }

    var body: some View {
        VStack {
            scoreHeader

            Spacer()

            List {
                switch selectedQuestionCategory {
                    case .correct:
                        QuestionSummaryList(for: .correct, questions: correctQuestions)
                    case .incorrect:
                        QuestionSummaryList(for: .incorrect, questions: incorrectQuestions)
                }
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
            var loadedProgress = SavedProgress.loadSavedProgress()
            let newProgress = SavedProgress(date: Date(), score: progress.score, numberOfQuestions: settings.numberOfQuestions, continents: settings.continents)

            loadedProgress.append(newProgress)

            SavedProgress.saveProgress(loadedProgress)
        }
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
