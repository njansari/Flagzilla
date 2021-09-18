//
//  LearnView.swift
//  LearnView
//
//  Created by Nayan Jansari on 04/09/2021.
//

import SwiftUI

enum LearnSettingsSection {
    case style
    case next
}

struct LearnView: View {
    @StateObject private var settings = LearnSettings()

    @State private var tab: LearnSettingsSection = .style

    var flagQuestionStyle: some View {
        VStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(.tint)
                .frame(height: 60)

            Spacer()

            HStack {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
            }
            .frame(height: 10)

            HStack {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
            }
            .frame(height: 10)
        }
        .foregroundStyle(.tertiary)
        .frame(width: 100, height: 100)
    }

    var flagAnswerStyle: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(.tint)
                .frame(height: 10)
                .padding(.top, 2)

            Spacer()

            HStack {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                RoundedRectangle(cornerRadius: 4, style: .continuous)
            }
            .frame(height: 30)

            HStack {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                RoundedRectangle(cornerRadius: 4, style: .continuous)
            }
            .frame(height: 30)
        }
        .foregroundStyle(.tertiary)
        .frame(width: 100, height: 100)
    }

    var unselectedImage: some View {
        Image(systemName: "circle")
            .foregroundStyle(.quaternary)
    }

    var selectedImage: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.tint)
    }

    var body: some View {
        NavigationView {
            TabView(selection: $tab) {
                Form {
                    Section("Question and Answer Style") {
                        HStack {
                            Spacer()

                            VStack(spacing: 10) {
                                flagQuestionStyle

                                Text("Flag Question")

                                switch settings.style {
                                    case .flagQuestion: selectedImage
                                    case .flagAnswer: unselectedImage
                                }
                            }
                            .onTapGesture {
                                settings.style = .flagQuestion
                            }

                            Spacer()
                            Spacer()
                            Spacer()

                            VStack(spacing: 10) {
                                flagAnswerStyle

                                Text("Flag Answer")

                                switch settings.style {
                                    case .flagQuestion: unselectedImage
                                    case .flagAnswer: selectedImage
                                }
                            }
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
                            tab = .next
                        }
                    }
                    .buttonStyle(.listRow)
                }
                .tag(LearnSettingsSection.style)

                Text("Next")
                    .tag(LearnSettingsSection.next)
            }
            .navigationTitle("Learn")
            .tabViewStyle(.page)
            .background(.groupedBackground)
        }
        .environmentObject(settings)
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
