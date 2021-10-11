//
//  Question.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 04/10/2021.
//

import Foundation

struct Question {
    let answer: Country
    let answers: [Country]

    var selectedAnswer: Country?

    init(country: Country, style: LearnSettings.QuestionAnswerStyle, answerContinents: Continents) {
        answer = country

        var allAnswers = [answer]

        let numberOfAnswers: Int = {
            switch style {
                case .flagToName: return 3
                case .nameToFlag: return 4
            }
        }()

        while allAnswers.count < numberOfAnswers {
            let newCountry = countries.filter { country in
                country.continents.isSupersetOrSubset(of: answerContinents)
            }.randomElement()!

            if !allAnswers.contains(newCountry) {
                allAnswers.append(newCountry)
            }
        }

        answers = allAnswers.shuffled()
    }

    var isCorrect: Bool {
        selectedAnswer == answer
    }
}
