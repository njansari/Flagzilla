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

    @State private var questionsSelection: Questions = .correct

    let dismissAction: DismissAction

    var percentage: Double {
        let percent = Double(progress.score) / Double(settings.numberOfQuestions)
        return (percent * 100).rounded(.down) / 100
    }

    var correctQuestions: [(offset: Int, _: Question)] {
        progress.questions.enumerated().filter { $0.element.isCorrect }
    }

    var incorrectQuestions: [(offset: Int, _: Question)] {
        progress.questions.enumerated().filter { !$0.element.isCorrect }
    }

    var scoreHeader: some View {
        VStack {
            ZStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(percentage))
                        .stroke(.green, lineWidth: questionsSelection == .correct ? 40 : 35)

                    Circle()
                        .trim(from: CGFloat(percentage), to: 1)
                        .stroke(.red, lineWidth: questionsSelection == .incorrect ? 40 : 35)
                }
                .rotationEffect(.radians(.pi / -2))
                .frame(width: 150, height: 150)
                .animation(.easeInOut, value: questionsSelection)

                VStack {
                    Text(percentage, format: .percent)
                        .font(.largeTitle.bold())

                    Text("\(progress.score)/\(settings.numberOfQuestions)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 220)

            QuestionsSummarySegmentedControl(questionSelection: $questionsSelection)
        }
        .padding(.horizontal)
    }

    var body: some View {
        VStack {
            scoreHeader

            Spacer()

            Form {
                switch questionsSelection {
                    case .correct:
                        if correctQuestions.isEmpty {
                            Text("You didn't answer any questions correctly")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(correctQuestions, id: \.offset) { question in
                                Text("Question \(question.offset + 1)")
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
                            ForEach(incorrectQuestions, id: \.offset) { question in
                                Text("Question \(question.offset + 1)")
                                    .font(.headline)
                            }
                        }
                }
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismissAction()
                    }
                }
            }
        }
        .background(.groupedBackground)
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
