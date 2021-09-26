//
//  QuestionStyleView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 18/09/2021.
//

import SwiftUI

struct QuestionStyleView: View {
    @EnvironmentObject private var settings: LearnSettings

    var unselectedImage: some View {
        Image(systemName: "circle")
            .foregroundStyle(.quaternary)
    }

    var selectedImage: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.tint)
    }

    var flagToNameStyleOption: some View {
        VStack(spacing: 10) {
            FlagToNameStyle()

            Text("Flag to Name")
                .font(.callout)

            switch settings.style {
                case .flagToName: selectedImage
                case .nameToFlag: unselectedImage
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
                case .flagToName: unselectedImage
                case .nameToFlag: selectedImage
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

            Toggle("Use country's official name", isOn: $settings.useOfficialName)
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
