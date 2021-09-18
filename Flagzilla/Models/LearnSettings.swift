//
//  LearnSettings.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 17/09/2021.
//

import SwiftUI

@MainActor class LearnSettings: ObservableObject {
    enum QuestionAnswerStyle: Int {
        case flagQuestion
        case flagAnswer
    }

    @AppStorage("qAndAStyle") var style: QuestionAnswerStyle = .flagQuestion

    @AppStorage("numberOfQuestions") private var numberOfQuestions = 10

//    @AppStorage("continents") private var continents: Continents = .all
}
