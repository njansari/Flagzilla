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

    init(country: Country) {
        answer = country

        var allAnswers = [answer]

        while allAnswers.count < 4 {
            let newCountry = countries.filter { $0.continents.contains(.oceania) }.randomElement()!

            if !allAnswers.contains(newCountry) {
                allAnswers.append(newCountry)
            }
        }

        answers = allAnswers
    }

    var isCorrect: Bool {
        selectedAnswer == answer
    }
}
