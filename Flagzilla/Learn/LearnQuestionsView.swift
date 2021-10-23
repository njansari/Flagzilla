//
//  LearnQuestionsView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 03/10/2021.
//

import SwiftUI

struct LearnQuestionsView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var progress = LearnProgress()

    @EnvironmentObject private var settings: LearnSettings

    @State private var showingDismissConfirmation = false

    var progressInfo: some View {
        ProgressView(value: progress.value, total: Double(settings.numberOfQuestions)) {
            Text("Question \(progress.questionNumber)")
                .fontWeight(.medium)
        } currentValueLabel: {
            if settings.showsAnswerAfterQuestion {
                Text("Score: **\(progress.score)**")
            }
        }
        .animation(.default, value: progress.value)
    }

    @ViewBuilder var question: some View {
        switch settings.style {
            case .flagToName:
                FlagToNameQuestionView()
            case .nameToFlag:
                NameToFlagQuestionView()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                progressInfo

                Spacer()

                question

                Spacer()

                toolbar
            }
            .multilineTextAlignment(.center)
            .navigationBarHidden(true)
            .padding()
        }
        .environmentObject(progress)
        .onAppear {
            progress.setup(settings: settings)
        }
    }
}

extension LearnQuestionsView {
    var backButton: some View {
        Button {
            progress.back()
        } label: {
            Image(systemName: "chevron.left")
                .imageScale(.large)

            Text("Back")
                .frame(alignment: .leading)
        }
        .foregroundColor(.accentColor)
    }

    var endButton: some View {
        Button(role: .destructive) {
            showingDismissConfirmation = true
        } label: {
            Text("End")
                .frame(maxWidth: 50)
        }
        .foregroundColor(.red)
        .confirmationDialog("Are you sure you want to end?", isPresented: $showingDismissConfirmation) {
            Button("End Now", role: .destructive, action: dismiss.callAsFunction)
        } message: {
            Text("Ending now will delete any progress made.")
        }
    }

    var nextButton: some View {
        Button {
            progress.next()
        } label: {
            Text("Next")
                .frame(alignment: .trailing)

            Image(systemName: "chevron.right")
                .imageScale(.large)
        }
        .foregroundColor(.accentColor)
    }

    var finishButton: some View {
        NavigationLink {
            LearnQuestionsSummary(dismissAction: dismiss)
        } label: {
            Text("Finish")
                .frame(alignment: .trailing)
        }
        .buttonStyle(.borderedProminent)
        .tint(.accentColor)
    }

    var toolbar: some View {
        HStack {
            backButton
                .opacity(settings.showsAnswerAfterQuestion || progress.questionNumber == 1 ? 0 : 1)

            Spacer()

            endButton

            Spacer()

            Group {
                if progress.questionNumber < progress.questions.count {
                    nextButton
                } else {
                    finishButton
                }
            }
            .opacity(progress.currentQuestion.selectedAnswer == nil ? 0 : 1)
        }
        .font(.title3.weight(.medium))
        .buttonStyle(.bordered)
        .tint(Color(uiColor: .systemBackground))
    }
}

struct LearnQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        LearnQuestionsView()
            .environmentObject(LearnSettings())
    }
}
