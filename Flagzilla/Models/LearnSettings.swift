//
//  LearnSettings.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 17/09/2021.
//

import SwiftUI

@MainActor final class LearnSettings: ObservableObject {
    enum QuestionAnswerStyle: Int {
        case flagToName
        case nameToFlag

        var numberOfAnswers: Int {
            switch self {
            case .flagToName: return 3
            case .nameToFlag: return 4
            }
        }
    }

    @AppStorage("qAndAStyle") var style: QuestionAnswerStyle = .flagToName
    @AppStorage("useOfficialName") var useOfficialName = false

    @AppStorage("continents") var continents: Continents = .all

    @AppStorage("numberOfQuestions") var numberOfQuestions = 10
    @AppStorage("showsAnswer") var showsAnswerAfterQuestion = true

    @AppStorage("useTimer") var useTimer = true
    @AppStorage("timerDuration") var timerDuration = 1

    static let timerDurations = [1, 2, 5, 10]
}
