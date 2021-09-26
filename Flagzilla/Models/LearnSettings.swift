//
//  LearnSettings.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 17/09/2021.
//

import SwiftUI

extension Comparable {
    mutating func clamp(to limits: ClosedRange<Self>) {
        self = min(max(self, limits.lowerBound), limits.upperBound)
    }
}

@MainActor class LearnSettings: ObservableObject {
    enum QuestionAnswerStyle: Int {
        case flagToName
        case nameToFlag
    }

    @AppStorage("qAndAStyle") var style: QuestionAnswerStyle = .flagToName

    @AppStorage("numberOfQuestions") var numberOfQuestions = 10

    @AppStorage("useOfficialName") var useOfficialName = false

    @AppStorage("useTimer") var useTimer = true

    @AppStorage("timerDuration") var timerDuration = 60

    @AppStorage("showsAnswer") var showsAnswerAfterQuestion = true

    let durations = [1, 2, 5, 10]

    @Published var continents: Continents {
        didSet {
            UserDefaults.standard.set(continents.rawValue, forKey: "continents")
        }
    }

    init() {
        let value = UserDefaults.standard.value(forKey: "continents") as? Int ?? Continents.all.rawValue
        continents = Continents(rawValue: value)
    }
}
