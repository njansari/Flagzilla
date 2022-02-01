//
//  OtherSettingsView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 26/09/2021.
//

import SwiftUI

struct OtherSettingsView: View {
    @EnvironmentObject private var settings: LearnSettings

    private var numberOfQuestionsTextField: some View {
        NumberTextField(value: $settings.numberOfQuestions) {
            settings.validateNumberOfQuestions()
        }
        .frame(maxWidth: 100)
    }

    var body: some View {
        Section {
            HStack {
                VStack(alignment: .leading) {
                    Text("Number of questions")

                    Text(settings.numberOfQuestionsRange, format: .integerInterval)
                        .font(.caption2)
                }

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
}

struct OtherSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            OtherSettingsView()
        }
        .environmentObject(LearnSettings())
    }
}
