//  FlagToNameQuestionView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 28/09/2021.
//

import SwiftUI

enum AnswerState {
    case none
    case unselected(isCorrect: Bool)
    case selected(isCorrect: Bool)
}

struct FlagToNameQuestionView: View {
    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    var body: some View {
        VStack(spacing: 80) {
            AsyncImage(url: progress.currentQuestion.answer.detailFlag, scale: 3, transaction: Transaction(animation: .easeIn(duration: 0.2))) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(color: .primary.opacity(0.4), radius: 5)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.quaternary)
                }
            }
            .frame(maxHeight: 200)

            VStack(spacing: 20) {
                ForEach(progress.currentQuestion.answers) { country in
                    Button {
                        progress.currentQuestion.selectedAnswer = country

                        if progress.currentQuestion.isCorrect {
                            progress.score += 1
                        }
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

struct FlagToNameQuestionView_Previews: PreviewProvider {
    static let questionCountry: Country = countries.randomElement()!

    static var answerCountries: [Country] {
        let country1 = countries.randomElement()!
        let country2 = countries.randomElement()!

        return [questionCountry, country1, country2].shuffled()
    }

    static var previews: some View {
        FlagToNameQuestionView()
            .environmentObject(LearnSettings())
            .environmentObject(LearnProgress())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
