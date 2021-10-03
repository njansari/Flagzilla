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

    var toolbar: some View {
        HStack {
            Button {
                progress.questionNumber -= 1
            } label: {
                Image(systemName: "chevron.left")
                    .imageScale(.large)

                Text("Back")
                    .frame(maxWidth: 50, alignment: .leading)
            }
            .foregroundColor(.accentColor)
            .tint(Color(uiColor: .systemBackground))

            Spacer()

            Button(role: .destructive) {
                showingDismissConfirmation = true
            } label: {
                Text("End")
                    .frame(maxWidth: 50)
            }
            .foregroundColor(.red)
            .tint(Color(uiColor: .systemBackground))
            .confirmationDialog("Are you sure you want to end?", isPresented: $showingDismissConfirmation) {
                Button("End Now", role: .destructive, action: dismiss.callAsFunction)
            } message: {
                Text("Ending now will delete any progress made.")
            }

            Spacer()

            Button {
                progress.questionNumber += 1
            } label: {
                Text("Next")
                    .frame(maxWidth: 50, alignment: .trailing)

                Image(systemName: "chevron.right")
                    .imageScale(.large)
            }
            .foregroundColor(.accentColor)
            .tint(Color(uiColor: .systemBackground))
        }
        .font(.title3.weight(.medium))
        .buttonStyle(.bordered)
    }

    var body: some View {
        VStack {
            ProgressView(value: Double(progress.questionNumber), total: Double(settings.numberOfQuestions)) {
//                Text("Question \(progress.questionNumber)")
            } currentValueLabel: {
                Text("Score: \(progress.score)")
            }
            .animation(.spring(), value: progress.questionNumber)

            Spacer()

            FlagToNameQuestionView(questionCountry: .example, answerCountries: [.example, countries[countries.startIndex], countries[countries.index(countries.startIndex, offsetBy: 1)]])

            Spacer()
        }
        .multilineTextAlignment(.center)
        .safeAreaInset(edge: .bottom) {
            toolbar
        }
        .padding()
    }
}

struct LearnQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        LearnQuestionsView()
            .environmentObject(LearnSettings())
    }
}
