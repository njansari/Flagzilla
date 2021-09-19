//
//  QuestionAnswerStyleView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 18/09/2021.
//

import SwiftUI

struct QuestionAnswerStyleView: View {
    @ObservedObject var settings: LearnSettings

    var unselectedImage: some View {
        Image(systemName: "circle")
            .foregroundStyle(.quaternary)
    }

    var selectedImage: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.tint)
    }
    
    var body: some View {
        Form {
            Section("Question and Answer Style") {
                HStack {
                    Spacer()

                    VStack(spacing: 10) {
                        FlagToTextStyle()

                        Text("Flag to Text")

                        switch settings.style {
                            case .flagQuestion: selectedImage
                            case .flagAnswer: unselectedImage
                        }
                    }
                    .frame(maxWidth: 100)
                    .onTapGesture {
                        settings.style = .flagQuestion
                    }

                    Spacer(minLength: 40)

                    VStack(spacing: 10) {
                        TextToFlagStyle()

                        Text("Text to Flag")

                        switch settings.style {
                            case .flagQuestion: unselectedImage
                            case .flagAnswer: selectedImage
                        }
                    }
                    .frame(maxWidth: 100)
                    .onTapGesture {
                        settings.style = .flagAnswer
                    }

                    Spacer()
                }
                .imageScale(.large)
                .font(.callout)
                .padding()
            }

            Button("Next") {
                withAnimation {
                    settings.section.next()
                }
            }
            .buttonStyle(.listRow)
        }
    }
}

struct QuestionAnswerStyleView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionAnswerStyleView(settings: LearnSettings())
    }
}
