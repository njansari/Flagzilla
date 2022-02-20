//
//  QuestionSummaryCategory.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 09/10/2021.
//

import SwiftUI

enum QuestionSummaryCategory: String, CaseIterable {
    case correct
    case incorrect
    case unanswered

    var color: Color {
        switch self {
        case .correct:
            return .green
        case .incorrect:
            return .red
        case .unanswered:
            return .gray
        }
    }

    var noAnswersLabel: String {
        switch self {
        case .correct:
            return "You didn't answer any questions correctly"
        case .incorrect:
            return "You answered every question correctly"
        case .unanswered:
            return "You answered every question"
        }
    }
}
