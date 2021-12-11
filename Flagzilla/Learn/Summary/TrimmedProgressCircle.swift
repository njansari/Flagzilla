//
//  TrimmedProgressCircle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 04/12/2021.
//

import SwiftUI

struct TrimmedProgressCircle: View {
    @EnvironmentObject private var progress: LearnProgress

    @Binding private var selectedCategory: QuestionSummaryCategory

    private let category: QuestionSummaryCategory

    init(for category: QuestionSummaryCategory, selectedCategory: Binding<QuestionSummaryCategory>) {
        self.category = category
        _selectedCategory = selectedCategory
    }

    private var questionBreakdown: Double {
        switch category {
        case .correct:
            return progress.percentageBreakdown.correct
        case .incorrect:
            return progress.percentageBreakdown.incorrect
        case .unanswered:
            return progress.percentageBreakdown.unanswered
        }
    }

    private var trimFrom: Double {
        switch category {
        case .correct:
            return 0
        case .incorrect:
            return progress.percentageBreakdown.correct
        case .unanswered:
            return progress.percentageBreakdown.correct + progress.percentageBreakdown.incorrect
        }
    }

    private var trimTo: Double {
        switch category {
        case .correct:
            return progress.percentageBreakdown.correct
        case .incorrect:
            return progress.percentageBreakdown.correct + progress.percentageBreakdown.incorrect
        case .unanswered:
            return 1
        }
    }

    var body: some View {
        Circle()
            .trim(from: trimFrom, to: trimTo)
            .stroke(category.color, lineWidth: selectedCategory == category ? 40 : 35)
            .onTapGesture { selectedCategory = category }
    }
}

struct TrimmedProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        TrimmedProgressCircle(for: .correct, selectedCategory: .constant(.correct))
            .environmentObject(LearnProgress())
    }
}
