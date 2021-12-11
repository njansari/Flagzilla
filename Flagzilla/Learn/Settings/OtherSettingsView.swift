//
//  OtherSettingsView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 26/09/2021.
//

import SwiftUI

struct OtherSettingsView: View {
    @EnvironmentObject private var settings: LearnSettings

    @FocusState private var numberOfQuestionsFocused: Bool

    private var maxCountries: Int {
        countries.filter { $0.continents.isSupersetOrSubset(of: settings.continents) }.count
    }

    private var numberOfQuestionsTextField: some View {
        let promptText = Text("max \(maxCountries)")

        return TextField("Number of questions", value: $settings.numberOfQuestions, format: .number, prompt: promptText)
            .foregroundColor(numberOfQuestionsFocused ? .primary : .accentColor)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: 100)
            .keyboardType(.numberPad)
            .focused($numberOfQuestionsFocused)
            .toolbar { keyboardDoneToolbarButton }
    }

    private var keyboardDoneToolbarButton: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()

            Button("Done") {
                numberOfQuestionsFocused = false
                validateNumberOfQuestions()
            }
            .font(.body.bold())
        }
    }

    var body: some View {
        Section {
            HStack {
                Text("Number of questions")

                Spacer()

                numberOfQuestionsTextField
            }

            Toggle("Show answer after each question", isOn: $settings.showsAnswerAfterQuestion)
                .tint(.accentColor)
        } header: {
            Text("Questions")
        } footer: {
            Text("When this is off, the current score is not displayed.")
        }

        Section {
            NavigationLink(destination: TimerView.init) {
                Text("Timer")
                    .badge(settings.useTimer ? "On" : "Off")
            }
        }
    }

    private func validateNumberOfQuestions() {
        let range = 2...maxCountries

        if !range.contains(settings.numberOfQuestions) {
            settings.numberOfQuestions.clamp(to: range)
        }
    }
}

struct OtherSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            OtherSettingsView()
        }
        .environmentObject(LearnSettings())
    }
}
