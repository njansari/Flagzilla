//
//  QuestionsSummarySegmentedControl.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 07/10/2021.
//

import SwiftUI

enum Questions: String, CaseIterable {
    case correct
    case incorrect
}

struct QuestionsSummarySegmentedControl: UIViewRepresentable {
    @Binding var questionSelection: Questions

    func makeUIView(context: Context) -> UISegmentedControl {
        let actions = Questions.allCases.map { questionType in
            UIAction(title: questionType.rawValue.localizedCapitalized) { action in
                questionSelection = questionType

                if let sender = action.sender as? UISegmentedControl {
                    let color: UIColor = {
                        switch questionType {
                            case .correct: return .systemGreen
                            case .incorrect: return .systemRed
                        }
                    }()

                    sender.selectedSegmentTintColor = color
                }
            }
        }

        let control = UISegmentedControl(frame: .zero, actions: actions)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

        return control
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.selectedSegmentIndex = Questions.allCases.firstIndex(of: questionSelection) ?? 0

        let color: UIColor = {
            let questionType = Questions.allCases[uiView.selectedSegmentIndex]

            switch questionType {
                case .correct: return .systemGreen
                case .incorrect: return .systemRed
            }
        }()

        uiView.selectedSegmentTintColor = color
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsSummarySegmentedControl(questionSelection: .constant(.correct))
    }
}
