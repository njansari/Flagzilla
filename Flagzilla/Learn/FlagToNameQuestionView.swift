//
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

    @State private var selectedAnswer: Country?

    let questionCountry: Country
    let answerCountries: [Country]

    var body: some View {
        VStack(spacing: 50) {
            AsyncImage(url: questionCountry.detailFlag, scale: 3, transaction: Transaction(animation: .easeIn(duration: 0.2))) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(color: .primary.opacity(0.4), radius: 5)
                } else {
                    Rectangle()
                        .fill(.quaternary)
                        .cornerRadius(10)
                }
            }
            .frame(height: 200)
            .padding()

            VStack(spacing: 20) {
                ForEach(answerCountries) { country in
                    Button {
                        selectedAnswer = country
                    } label: {
                        Text(country.name)
                            .font(.title3.weight(.medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.answerOption(state: stateForAnswer(country: country)))
                    .controlSize(.large)
                    .allowsHitTesting(selectedAnswer == nil || !settings.showsAnswerAfterQuestion)
                }
            }
            .padding()
        }
    }

    func stateForAnswer(country: Country) -> AnswerState {
        guard let selectedAnswer = selectedAnswer else {
            return .none
        }

        let isCorrect = country == questionCountry

        if country == selectedAnswer {
            return .selected(isCorrect: isCorrect)
        } else {
            return .unselected(isCorrect: isCorrect)
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
        FlagToNameQuestionView(questionCountry: questionCountry, answerCountries: answerCountries)
            .environmentObject(LearnSettings())
    }
}
