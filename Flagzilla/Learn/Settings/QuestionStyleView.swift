//
//  QuestionStyleView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 18/09/2021.
//

import SwiftUI

struct QuestionStyleView: View {
    @EnvironmentObject private var settings: LearnSettings

    private var flagToNameStyleOption: some View {
        VStack(spacing: 10) {
            FlagToNameStyle()

            Text("Flag to Name")
                .font(.callout)

            switch settings.style {
            case .flagToName: Image.selectedCheckmark
            case .nameToFlag: Image.unselectedCheckmark
            }
        }
        .frame(maxWidth: 100)
        .onTapGesture { settings.style = .flagToName }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Flag to name")
        .accessibilityValue("One flag as a question and three names as answer options.")
        .accessibilityAddTraits(settings.style == .flagToName ? .isSelected : [])
    }

    private var nameToFlagStyleOption: some View {
        VStack(spacing: 10) {
            NameToFlagStyle()

            Text("Name to Flag")
                .font(.callout)

            switch settings.style {
            case .flagToName: Image.unselectedCheckmark
            case .nameToFlag: Image.selectedCheckmark
            }
        }
        .frame(maxWidth: 100)
        .onTapGesture { settings.style = .nameToFlag }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Name to flag")
        .accessibilityValue("One name as a question and four flags as answer options.")
        .accessibilityAddTraits(settings.style == .nameToFlag ? .isSelected : [])
    }
    
    var body: some View {
        Section("Question Style") {
            HStack {
                Spacer()

                flagToNameStyleOption

                Spacer()

                nameToFlagStyleOption

                Spacer()
            }
            .imageScale(.large)
            .padding(.vertical)
            .listRowInsets(.init())

            Toggle("Use countries' official name", isOn: $settings.useOfficialName)
                .tint(.accentColor)
        }
    }
}

struct QuestionStyleView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            QuestionStyleView()
                .environmentObject(LearnSettings())
        }
    }
}
