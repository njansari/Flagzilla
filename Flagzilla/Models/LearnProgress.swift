//
//  LearnProgress.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/10/2021.
//

import SwiftUI

@MainActor class LearnProgress: ObservableObject {
    @Published var questionNumber = 1 {
        didSet {
            currentQuestion = questions[questionNumber - 1]
        }
    }

    @Published var score = 0

    @Published var currentQuestion: Question = .example {
        didSet {
            if let index = questions.firstIndex(where: { $0.answer == currentQuestion.answer }) {
                questions[index].selectedAnswer = currentQuestion.selectedAnswer
            }
        }
    }

    var questions: [Question] = []

    var value: Double {
        let questionsCompleted = Double(questionNumber) - 1

        if currentQuestion.selectedAnswer == nil {
            return questionsCompleted + 0.5
        } else {
            return questionsCompleted + 1
        }
    }

    func setup(settings: LearnSettings) {
        let allCountries = countries.filter { country in
            country.continents.isSupersetOrSubset(of: settings.continents)
        }

        let questionCountries = allCountries.prefix(settings.numberOfQuestions)

        let allQuestions = questionCountries.map { country in
            Question(country: country, style: settings.style, answerContinents: settings.continents)
        }

        questions = allQuestions.shuffled()
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
