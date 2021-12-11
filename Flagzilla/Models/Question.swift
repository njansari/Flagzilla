//
//  Question.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 04/10/2021.
//

import Foundation

struct Question {
    let answer: Country
    let answerOptions: [Country]

    var selectedAnswer: Country?

    init(country: Country, style: LearnSettings.QuestionAnswerStyle, answerContinents: Continents) {
        answer = country

        var allAnswers = [answer]

        var allCountries = countries
        allCountries.remove(answer)

        let wrongAnswers = allCountries.filter { country in
            country.continents.isSupersetOrSubset(of: answerContinents)
        }.randomSample(count: style.numberOfAnswers - 1)

        allAnswers.append(contentsOf: wrongAnswers)

        answerOptions = allAnswers.shuffled()
    }

    var isCorrect: Bool {
        selectedAnswer == answer
    }

    var isAnswered: Bool {
        selectedAnswer != nil
    }

    static var example: Question {
        var question = Question(country: .example, style: .flagToName, answerContinents: .all)
        question.selectedAnswer = .example

        return question
    }
}
