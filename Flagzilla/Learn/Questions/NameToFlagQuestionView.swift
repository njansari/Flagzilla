//
//  NameToFlagQuestionView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 05/10/2021.
//

import SwiftUI

struct NameToFlagQuestionView: View {
    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    private let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 150), spacing: 20), count: 2)

    private var questionCountryName: String {
        settings.useOfficialName ? progress.currentQuestion.answer.officialName : progress.currentQuestion.answer.name
    }

    private var questionText: some View {
        Text(questionCountryName)
            .font(.title.bold())
    }

    private var answerOptions: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(progress.currentQuestion.answerOptions) { country in
                Button {
                    progress.setCurrentQuestionAnswer(to: country)
                } label: {
                    image(for: country)
                        .padding(.vertical, 5)
                }
                .buttonStyle(.answerOption(state: stateForAnswer(country: country)))
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

    private func image(for country: Country) -> some View {
        AsyncFlagImage(url: country.mediumFlag, animation: .easeIn(duration: 0.2)) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(5)
                .shadow(color: .primary.opacity(0.4), radius: 5)
        } placeholder: {
            RoundedRectangle(cornerRadius: 5)
                .fill(.quaternary)
        }
        .frame(width: 150, height: 75)
    }

    private func stateForAnswer(country: Country) -> AnswerState {
        guard let selectedAnswer = progress.currentQuestion.selectedAnswer else { return .none }

        let isCorrect = country == progress.currentQuestion.answer

        if country == selectedAnswer {
            return .selected(isCorrect: isCorrect)
        } else {
            return .unselected(isCorrect: isCorrect)
        }
    }

    private func buttonAllowsHitTesting(country: Country) -> Bool {
        if settings.showsAnswerAfterQuestion {
            return !progress.currentQuestion.isAnswered
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
