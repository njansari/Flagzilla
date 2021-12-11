//
//  LearnProgress.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/10/2021.
//

import SwiftUI

@MainActor final class LearnProgress: ObservableObject {
    typealias QuestionBreakdown = (correct: Double, incorrect: Double, unanswered: Double)

    @Published var questionNumber = 1 {
        didSet {
            currentQuestion = questions[questionNumber - 1]
        }
    }

    @Published var currentQuestion: Question = .example {
        didSet {
            if let index = questions.firstIndex(where: { $0.answer == currentQuestion.answer }) {
                questions[index].selectedAnswer = currentQuestion.selectedAnswer
            }
        }
    }

    @Published private(set) var score = 0
    @Published var timeRemaining = 0

    private var settings = LearnSettings()

    private(set) var questions: [Question] = []

    var progressValue: Double {
        let questionsCompleted = Double(questionNumber) - 1

        if currentQuestion.selectedAnswer == nil {
            return questionsCompleted + 0.5
        } else {
            return questionsCompleted + 1
        }
    }

    var timeElapsed: Int {
        settings.timerDuration * 60 - timeRemaining
    }

    var questionRate: Double {
        Double(timeElapsed) / Double(questionNumber)
    }

    var percentageBreakdown: QuestionBreakdown {
        let correct = Double(correctQuestions.count) / Double(settings.numberOfQuestions)
        let incorrect = Double(incorrectQuestions.count) / Double(settings.numberOfQuestions)
        let unanswered = Double(unansweredQuestions.count) / Double(settings.numberOfQuestions)

        return (correct, incorrect, unanswered)
    }

    var correctQuestions: [EnumeratedQuestion] {
        questions.enumerated().filter { $0.element.isCorrect }
    }

    var incorrectQuestions: [EnumeratedQuestion] {
        questions.enumerated().filter { !$0.element.isCorrect && $0.element.isAnswered }
    }

    var unansweredQuestions: [EnumeratedQuestion] {
        questions.enumerated().filter { !$0.element.isAnswered }
    }

    func setup(settings: LearnSettings) {
        self.settings = settings

        let allCountries = countries.filter { country in
            country.continents.isSupersetOrSubset(of: settings.continents)
        }

        let questionCountries = allCountries.shuffled().prefix(settings.numberOfQuestions)

        questions = questionCountries.map { country in
            Question(country: country, style: settings.style, answerContinents: settings.continents)
        }

        currentQuestion = questions[0]
    }

    func setCurrentQuestionAnswer(to country: Country) {
        currentQuestion.selectedAnswer = country

        if currentQuestion.isCorrect {
            score += 1
        }
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
