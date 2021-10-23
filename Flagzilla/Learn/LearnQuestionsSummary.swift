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
    @State private var expandedQuestion = -1

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
                        if correctQuestions.isEmpty {
                            Text("You didn't answer any questions correctly")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(correctQuestions, id: \.offset) { question in
                                NavigationLink("Question \(question.offset + 1)") {

                                }
                                .font(.headline)
                            }
                        }
                    case .incorrect:
                        if incorrectQuestions.isEmpty {
                            Text("You didn't answer any questions incorrectly")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        } else {
                            // TODO: Add to own view for both correct and incorrect
                            ForEach(incorrectQuestions, id: \.offset) { question in
                                DisclosureGroup("Question \(question.offset + 1)", isExpanded: questionExpandedBinding(for: question.offset)) {
                                    HStack {
                                        AsyncImage(url: question.element.answer.detailFlag, scale: 3, transaction: Transaction(animation: .easeIn(duration: 0.2))) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(2)
                                                    .shadow(color: .primary.opacity(0.4), radius: 2)
                                            } else {
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(.quaternary)
                                            }
                                        }
                                        .frame(maxHeight: 40)
                                    }
                                }
                                .font(.headline)
                            }
                        }
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

    func questionExpandedBinding(for question: Int) -> Binding<Bool> {
        Binding {
            expandedQuestion == question
        } set: {
            if $0 {
                expandedQuestion = question
            } else {
                expandedQuestion = -1
            }
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
