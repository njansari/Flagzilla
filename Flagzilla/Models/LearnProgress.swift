//
//  LearnProgress.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/10/2021.
//

import SwiftUI

@MainActor class LearnProgress: ObservableObject {
    @EnvironmentObject private var settings: LearnSettings

    @Published var questionNumber = 1
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
            settings.continents.isSuperset(of: country.continents)
        }

        let allQuestions = allCountries.prefix(settings.numberOfQuestions)

        return allQuestions.map(Question.init).shuffled()
    }()

    init() {
        _settings = EnvironmentObject<LearnSettings>()

        currentQuestion = questions[questions.startIndex]
    }

    func back() {
        guard questionNumber > 1 else { return }

        questionNumber -= 1
        currentQuestion = questions[questions.index(questions.startIndex, offsetBy: questionNumber - 1)]
    }

    func next() {
        guard questionNumber < questions.count else { return }

        questionNumber += 1
        currentQuestion = questions[questions.index(questions.startIndex, offsetBy: questionNumber - 1)]
    }
}
