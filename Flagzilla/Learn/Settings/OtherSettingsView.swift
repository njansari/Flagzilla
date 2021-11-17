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

    var body: some View {
        Section {
            HStack {
                Text("Number of questions")

                Spacer()

                TextField("Number of questions", value: $settings.numberOfQuestions, format: .number, prompt: Text("max \(maxCountries)"))
                    .foregroundColor(numberOfQuestionsFocused ? .primary : .accentColor)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 100)
                    .keyboardType(.numberPad)
                    .focused($numberOfQuestionsFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()

                            Button("Done") {
                                numberOfQuestionsFocused = false

                                let range = 1...maxCountries

                                if !range.contains(settings.numberOfQuestions) {
                                    settings.numberOfQuestions.clamp(to: range)
                                }
                            }
                            .font(.body.bold())
                        }
                    }
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
}

struct OtherSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            OtherSettingsView()
        }
        .environmentObject(LearnSettings())
    }
}
