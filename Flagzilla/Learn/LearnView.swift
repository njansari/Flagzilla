//
//  LearnView.swift
//  LearnView
//
//  Created by Nayan Jansari on 04/09/2021.
//

import SwiftUI

enum Style {
    case flagQuestion
    case flagAnswer
}

struct LearnView: View {
    @State private var tab = 0
    @State private var style: Style = .flagQuestion

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
                    Section("Style") {
                        HStack {
                            Spacer()

                            VStack(spacing: 20) {
                                flagQuestionStyle

                                switch style {
                                    case .flagQuestion: selectedImage
                                    case .flagAnswer: unselectedImage
                                }
                            }
                            .onTapGesture {
                                style = .flagQuestion
                            }

                            Spacer()
                            Spacer()
                            Spacer()

                            VStack(spacing: 20) {
                                flagAnswerStyle

                                switch style {
                                    case .flagQuestion: unselectedImage
                                    case .flagAnswer: selectedImage
                                }
                            }
                            .onTapGesture {
                                style = .flagAnswer
                            }

                            Spacer()
                        }
                        .imageScale(.large)
                        .padding()
                    }

                    Button("Next") {

                    }
                    .buttonStyle(.listRow)
                }
                .tag(0)

                Text("Next")
                    .tag(1)
            }
            .navigationTitle("Learn")
            .tabViewStyle(.page)
            .background(.groupedBackground)
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
