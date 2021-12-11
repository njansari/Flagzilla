//
//  QuestionsSummarySegmentedControl.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 07/10/2021.
//

import SwiftUI

struct QuestionsSummarySegmentedControl: UIViewRepresentable {
    @Binding var questionCategory: QuestionSummaryCategory

    func makeUIView(context: Context) -> UISegmentedControl {
        let actions = QuestionSummaryCategory.allCases.map { questionType in
            UIAction(title: questionType.rawValue.localizedCapitalized) { action in
                questionCategory = questionType

                if let sender = action.sender as? UISegmentedControl {
                    sender.selectedSegmentTintColor = UIColor(questionType.color)
                }
            }
        }

        let control = UISegmentedControl(frame: .zero, actions: actions)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

        return control
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.selectedSegmentIndex = QuestionSummaryCategory.allCases.firstIndex(of: questionCategory)!
        uiView.selectedSegmentTintColor = UIColor(questionCategory.color)
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsSummarySegmentedControl(questionCategory: .constant(.correct))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
