//
//  OtherSettingsView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 26/09/2021.
//

import SwiftUI

struct OtherSettingsView: View {
    @EnvironmentObject private var settings: LearnSettings

    @FocusState var numberOfQuestionsFocused: Bool

    var maxCountries: Int {
        countries.filter { country in
            country.continents.isSupersetOrSubset(of: settings.continents)
        }.count
    }

    var numberOfQuestionsTextField: some View {
        TextField("Number of questions", value: $settings.numberOfQuestions, format: .number, prompt: Text("max \(maxCountries)"))
            .foregroundColor(numberOfQuestionsFocused ? .primary : .accentColor)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: 100)
            .keyboardType(.numberPad)
            .focused($numberOfQuestionsFocused)
            .toolbar {
                keyboardDoneToolbarButton
            }
    }

    var keyboardDoneToolbarButton: some ToolbarContent {
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

    func validateNumberOfQuestions() {
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
