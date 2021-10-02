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

    var body: some View {
        Section {
            HStack {
                Text("Number of questions")

                Spacer()

                TextField("Number of questions", value: $settings.numberOfQuestions, format: .number, prompt: Text("10-\(countries.count)"))
                    .foregroundColor(numberOfQuestionsFocused ? .primary : .accentColor)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 100)
                    .focused($numberOfQuestionsFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        let range = 10...countries.count

                        if !range.contains(settings.numberOfQuestions) {
                            settings.numberOfQuestions.clamp(to: range)
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
        NavigationView {
            List {
                OtherSettingsView()
            }
        }
        .environmentObject(LearnSettings())
    }
}
