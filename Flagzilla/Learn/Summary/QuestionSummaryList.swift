//
//  QuestionSummaryList.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 10/11/2021.
//

import SwiftUI

struct QuestionSummaryList: View {
    @EnvironmentObject private var progress: LearnProgress

    private let category: QuestionSummaryCategory
    private let style: LearnSettings.QuestionAnswerStyle

    init(for category: QuestionSummaryCategory, questionStyle: LearnSettings.QuestionAnswerStyle) {
        self.category = category
        style = questionStyle
    }

    private var questions: [EnumeratedQuestion] {
        switch category {
        case .correct:
            return progress.correctQuestions
        case .incorrect:
            return progress.incorrectQuestions
        case .unanswered:
            return progress.unansweredQuestions
        }
    }

    private var noQuestionsText: some View {
        Text(category.noAnswersLabel)
            .font(.headline)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }

    private var questionsList: some View {
        ForEach(questions, id: \.offset) { question in
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Question \(question.offset + 1)")
                        .bold()

                    Spacer()

                    if category == .incorrect {
                        userAnswer(for: question)
                    }

                    Spacer()
                }

                Spacer(minLength: 50)

                VStack {
                    image(for: question.element.answer)
                        .frame(height: 60)
                        .frame(maxWidth: 120)

                    Text(question.element.answer.name)
                        .font(.caption.bold())
                        .minimumScaleFactor(0.1)
                        .multilineTextAlignment(.center)
                        .frame(width: 120)
                }
            }
            .padding(.vertical)
        }
        .listRowSeparatorTint(category.color)
    }

    var body: some View {
        List {
            if questions.isEmpty {
                noQuestionsText
            } else {
                questionsList
            }
        }
        .listStyle(.insetGrouped)
    }

    private func image(for country: Country) -> some View {
        AsyncFlagImage(url: country.miniFlag, animation: .easeIn(duration: 0.1)) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(2)
                .shadow(color: .primary.opacity(0.4), radius: 2)
        } placeholder: {
            RoundedRectangle(cornerRadius: 2)
                .fill(.quaternary)
        }
    }

    private func userAnswer(for question: EnumeratedQuestion) -> some View {
        Group {
            if let selectedCountry = question.element.selectedAnswer {
                switch style {
                case .flagToName:
                    Text("You chose: **\(selectedCountry.name)**")
                case .nameToFlag:
                    HStack {
                        Text("You chose: ")

                        image(for: selectedCountry)
                            .frame(height: 40)
                            .frame(maxWidth: 80, alignment: .leading)
                    }
                }
            }
        }
        .font(.caption)
    }
}

struct QuestionSummaryList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuestionSummaryList(for: .incorrect, questionStyle: .flagToName)
            QuestionSummaryList(for: .incorrect, questionStyle: .nameToFlag)
        }
        .environmentObject(LearnProgress())
    }
}
