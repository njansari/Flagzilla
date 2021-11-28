//
//  QuestionStyleView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 18/09/2021.
//

import SwiftUI

struct QuestionStyleView: View {
    @EnvironmentObject private var settings: LearnSettings

    var flagToNameStyleOption: some View {
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
        .onTapGesture {
            settings.style = .flagToName
        }
    }

    var nameToFlagStyleOption: some View {
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
        .onTapGesture {
            settings.style = .nameToFlag
        }
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
            .listRowInsets(EdgeInsets())

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
