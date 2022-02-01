//
//  LearnQuestionsToolbar.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 03/12/2021.
//

import SwiftUI

struct LearnQuestionsToolbar: View {
    @EnvironmentObject private var settings: LearnSettings
    @EnvironmentObject private var progress: LearnProgress

    @State private var showingDismissConfirmation = false
    @Binding var isFinished: Bool

    let dismissAction: DismissAction

    private var backButtonOpacity: Double {
        settings.showsAnswerAfterQuestion || progress.questionNumber == 1 ? 0 : 1
    }

    private var showNextButton: Bool {
        progress.questionNumber < progress.questions.count
    }

    private var backButton: some View {
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

    private var endButton: some View {
        Button(role: .destructive) {
            showingDismissConfirmation = true
        } label: {
            Text("End")
                .frame(maxWidth: 50)
        }
        .foregroundColor(.red)
        .confirmationDialog("Are you sure you want to end?", isPresented: $showingDismissConfirmation) {
            Button("End Now", role: .destructive, action: dismissAction.callAsFunction)
        } message: {
            Text("Ending now will delete any progress made.")
        }
    }

    private var nextButton: some View {
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

    private var finishButton: some View {
        NavigationLink(isActive: $isFinished) {
            LearnQuestionsSummary(dismissAction: dismissAction)
        } label: {
            Text("Finish")
                .frame(alignment: .trailing)
        }
        .buttonStyle(.borderedProminent)
        .tint(.accentColor)
    }

    var body: some View {
        HStack {
            backButton
                .opacity(backButtonOpacity)

            Spacer()

            endButton

            Spacer()

            ZStack {
                if showNextButton {
                    nextButton
                }

                finishButton
                    .opacity(!showNextButton ? 1 : 0)
            }
            .opacity(progress.currentQuestion.isAnswered ? 1 : 0)
        }
        .font(.title3.weight(.medium))
        .buttonStyle(.bordered)
        .tint(.backgroundColor)
    }
}

struct LearnQuestionsToolbar_Previews: PreviewProvider {
    @Environment(\.dismiss) static private var dismiss

    static var previews: some View {
        LearnQuestionsToolbar(isFinished: .constant(false), dismissAction: dismiss)
    }
}
