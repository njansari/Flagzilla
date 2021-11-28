//  NameToFlagQuestionView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 05/10/2021.
//

import SwiftUI

struct NameToFlagQuestionView: View {
    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    let columns = [GridItem(.flexible(minimum: 150), spacing: 20), GridItem(.flexible(minimum: 150), spacing: 20)]

    var questionText: some View {
        Text(settings.useOfficialName ? progress.currentQuestion.answer.officialName : progress.currentQuestion.answer.name)
            .font(.title.bold())
    }

    var answerOptions: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(progress.currentQuestion.answerOptions) { country in
                Button {
                    progress.currentQuestion.selectedAnswer = country

                    if progress.currentQuestion.isCorrect {
                        progress.score += 1
                    }
                } label: {
                    image(for: country)
                }
                .buttonStyle(.answerOption(state: stateForAnswer(country: country)))
                .controlSize(.large)
                .allowsHitTesting(buttonAllowsHitTesting(country: country))
            }
        }
    }

    var body: some View {
        VStack(spacing: 80) {
            questionText
            answerOptions
        }
    }

    func image(for country: Country) -> some View {
        AsyncImage(url: country.gridFlag, scale: 3, transaction: Transaction(animation: .easeIn(duration: 0.2))) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                    .shadow(color: .primary.opacity(0.4), radius: 5)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.quaternary)
            }
        }
        .frame(width: 150, height: 75)
    }

    func stateForAnswer(country: Country) -> AnswerState {
        guard let selectedAnswer = progress.currentQuestion.selectedAnswer else {
            return .none
        }

        let isCorrect = country == progress.currentQuestion.answer

        if country == selectedAnswer {
            return .selected(isCorrect: isCorrect)
        } else {
            return .unselected(isCorrect: isCorrect)
        }
    }

    func buttonAllowsHitTesting(country: Country) -> Bool {
        if settings.showsAnswerAfterQuestion {
            return progress.currentQuestion.selectedAnswer == nil
        } else {
            return progress.currentQuestion.selectedAnswer != country
        }
    }
}

struct NameToFlagQuestionView_Previes: PreviewProvider {
    static var previews: some View {
        NameToFlagQuestionView()
            .environmentObject(LearnSettings())
            .environmentObject(LearnProgress())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
