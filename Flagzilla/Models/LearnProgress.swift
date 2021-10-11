//
//  LearnProgress.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/10/2021.
//

import SwiftUI

@MainActor class LearnProgress: ObservableObject {
    @EnvironmentObject private var settings: LearnSettings

    @Published var questionNumber = 1 {
        didSet {
            currentQuestion = questions[questionNumber - 1]
        }
    }

    @Published var score = 0

    @Published var currentQuestion: Question {
        didSet {
            if let index = questions.firstIndex(where: { $0.answer == currentQuestion.answer }) {
                questions[index].selectedAnswer = currentQuestion.selectedAnswer
            }
        }
    }

    var questions: [Question] = {
        let settings = LearnSettings()

        let allCountries = countries.filter { country in
            country.continents.isSupersetOrSubset(of: settings.continents)
        }

        let allQuestions = allCountries.prefix(settings.numberOfQuestions)

        return allQuestions.map { country in
            Question(country: country, style: settings.style, answerContinents: settings.continents)
        }.shuffled()
    }()

    init() {
        _settings = EnvironmentObject<LearnSettings>()
        currentQuestion = questions[0]
    }

    func back() {
        if questionNumber > 1 {
            questionNumber -= 1
        }
    }

    func next() {
        if questionNumber < questions.count {
            questionNumber += 1
        }
    }
}
