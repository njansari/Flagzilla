//
//  QuestionSummaryList.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 10/11/2021.
//

import SwiftUI

struct QuestionSummaryList: View {
    let category: QuestionSummaryCategory
    let questionsStyle: LearnSettings.QuestionAnswerStyle
    let questions: [EnumeratedQuestion]

    var noQuestionsText: some View {
        Text(category.noAnswersLabel)
            .font(.headline)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }

    var questionsList: some View {
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
        if questions.isEmpty {
            noQuestionsText
        } else {
            questionsList
        }
    }

    func image(for country: Country) -> some View {
        let transaction = Transaction(animation: .easeIn(duration: 0.1))

        return AsyncImage(url: country.summmaryFlag, scale: 3, transaction: transaction) { phase in
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
    }

    func userAnswer(for question: EnumeratedQuestion) -> some View {
        Group {
            if let selectedCountry = question.element.selectedAnswer {
                switch questionsStyle {
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
        List {
            QuestionSummaryList(category: .incorrect, questionsStyle: .flagToName, questions: (0...10).map { ($0, .example) })
        }

        List {
            QuestionSummaryList(category: .incorrect, questionsStyle: .nameToFlag, questions: (0...10).map { ($0, .example) })
        }
    }
}
