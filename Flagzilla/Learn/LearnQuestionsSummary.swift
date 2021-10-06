//
//  LearnQuestionsSummary.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 05/10/2021.
//

import SwiftUI

struct LearnQuestionsSummary: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    var body: some View {
        Form {
            Section {
                InformationRowView(label: "Score", content: progress.score.formatted())
                InformationRowView(label: "Number of questions", content: settings.numberOfQuestions.formatted())
            } header: {
                Text(Double(progress.score) / Double(settings.numberOfQuestions), format: .percent)
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity)
            }
            .headerProminence(.increased)
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct LearnQuestionsSummary_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LearnQuestionsSummary()
        }
        .environmentObject(LearnSettings())
        .environmentObject(LearnProgress())
    }
}
