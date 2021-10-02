//
//  AnswerOptionButtonStyle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/10/2021.
//

import SwiftUI

struct AnswerOptionButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject private var settings: LearnSettings

    let state: AnswerState

    func tintColor(isCorrect: Bool) -> Color? {
        if settings.showsAnswerAfterQuestion {
            return isCorrect ? .green : .red
        } else {
            return nil
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        switch state {
            case .none:
                Button(configuration)
                    .buttonStyle(.bordered)
            case .unselected(let isCorrect):
                Button(configuration)
                    .buttonStyle(.bordered)
                    .tint(tintColor(isCorrect: isCorrect))
            case .selected(let isCorrect):
                Button(configuration)
                    .buttonStyle(.borderedProminent)
                    .tint(tintColor(isCorrect: isCorrect))
        }
    }
}

extension PrimitiveButtonStyle where Self == AnswerOptionButtonStyle {
    static func answerOption(state: AnswerState) -> AnswerOptionButtonStyle {
        AnswerOptionButtonStyle(state: state)
    }
}
