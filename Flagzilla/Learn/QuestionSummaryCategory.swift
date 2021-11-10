//
//  QuestionSummaryCategory.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 09/10/2021.
//

import UIKit

enum QuestionSummaryCategory: String, CaseIterable {
    case correct
    case incorrect

    var color: UIColor {
        switch self {
            case .correct: return .systemGreen
            case .incorrect: return .systemRed
        }
    }


    var noAnswersLabel: String {
        switch self {
            case .correct:
                return "You didn't answer any questions correctly"
            case .incorrect:
                return "You didn't answer any questions incorrectly"
        }
    }
}
