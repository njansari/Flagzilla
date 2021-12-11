//  FlagToNameQuestionView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 28/09/2021.
//

import SwiftUI

struct FlagToNameQuestionView: View {
    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    private var questionFlagImage: some View {
        AsyncFlagImage(url: progress.currentQuestion.answer.largeFlag, animation: .easeIn(duration: 0.2)) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .shadow(color: .primary.opacity(0.4), radius: 5)
        } placeholder: {
            RoundedRectangle(cornerRadius: 10)
                .fill(.quaternary)
        }
        .frame(maxHeight: 200)
    }

    private var answerOptions: some View {
        VStack(spacing: 20) {
            ForEach(progress.currentQuestion.answerOptions) { country in
                Button {
                    progress.setCurrentQuestionAnswer(to: country)
                } label: {
                    Text(settings.useOfficialName ? country.officialName : country.name)
                        .font(.title3.weight(.medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.answerOption(state: stateForAnswer(country: country)))
                .controlSize(.large)
                .allowsHitTesting(buttonAllowsHitTesting(country: country))
            }
        }
    }

    var body: some View {
        VStack(spacing: 80) {
            questionFlagImage
            answerOptions
        }
    }

    private func stateForAnswer(country: Country) -> AnswerState {
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

    private func buttonAllowsHitTesting(country: Country) -> Bool {
        if settings.showsAnswerAfterQuestion {
            return !progress.currentQuestion.isAnswered
        } else {
            return progress.currentQuestion.selectedAnswer != country
        }
    }
}

struct FlagToNameQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        FlagToNameQuestionView()
            .environmentObject(LearnSettings())
            .environmentObject(LearnProgress())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
