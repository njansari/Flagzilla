//
//  LearnSettings.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 17/09/2021.
//

import SwiftUI

@MainActor class LearnSettings: ObservableObject {
    enum Section: Int {
        case style
        case continents
        case next

        mutating func next() {
            self = Section(rawValue: rawValue + 1) ?? .next
        }
    }

    enum QuestionAnswerStyle: Int {
        case flagToName
        case nameToFlag
    }

    @AppStorage("qAndAStyle") var style: QuestionAnswerStyle = .flagToName

    @AppStorage("numberOfQuestions") var numberOfQuestions = 10

    @Published var continents: Continents = .all

    @Published var section: Section = .style
}
