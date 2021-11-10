//
//  QuestionSummaryList.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 10/11/2021.
//

import SwiftUI

struct QuestionSummaryList: View {
    @State private var expandedQuestion = 0

    let category: QuestionSummaryCategory
    let questions: [(offset: Int, element: Question)]

    init(for category: QuestionSummaryCategory, questions: [(offset: Int, element: Question)]) {
        self.category = category
        self.questions = questions
    }

    var body: some View {
        if questions.isEmpty {
            Text(category.noAnswersLabel)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        } else {
            ForEach(questions, id: \.offset) { question in
                DisclosureGroup(isExpanded: questionExpandedBinding(for: question.offset)) {
                    HStack {
                        AsyncImage(url: question.element.answer.summmaryFlag, scale: 3, transaction: Transaction(animation: .easeIn(duration: 0.1))) { phase in
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
                        .frame(height: 60)
                        .frame(maxWidth: 120, alignment: .leading)

                        Spacer()

                        VStack(alignment: .trailing, spacing: 5) {
                            Text(question.element.answer.name)
                                .bold()

                            if category == .incorrect {
                                (Text("You chose: ") + Text(question.element.selectedAnswer!.name).fontWeight(.medium))
                                    .font(.caption)
                            }
                        }
                        .multilineTextAlignment(.trailing)
                    }
                } label: {
                    Text("Question \(question.offset + 1)")
                        .fontWeight(.medium)
                }
            }
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

struct QuestionSummaryList_Previews: PreviewProvider {
    static var previews: some View {
        List {
            QuestionSummaryList(for: .incorrect, questions: (0...10).map { ($0, .example) })
        }
    }
}
