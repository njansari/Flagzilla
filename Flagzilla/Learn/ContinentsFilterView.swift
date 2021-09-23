//
//  ContinentsFilterView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 19/09/2021.
//

import SwiftUI

struct ContinentsFilterView: View {
    @ObservedObject var settings: LearnSettings

    var body: some View {
        Form {
            Section {
                ForEach(Continent.allCases, id: \.self) { continent in
                    HStack {
                        Text(continent.rawValue)

                        Spacer()

                        Button {
                            if settings.continents.contains(continent) && settings.continents.count > 1 {
                                settings.continents.remove(continent)
                            } else {
                                settings.continents.insert(continent)
                            }
                        } label: {
                            if settings.continents.contains(continent) {
                                Image(systemName: "checkmark")
                                    .font(.body.bold())
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    Text("Continents")

                    Spacer()

                    Button("Select All") {
                        settings.continents = .all
                    }
                    .disabled(settings.continents == .all)
                }
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

struct ContinentsFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ContinentsFilterView(settings: LearnSettings())
    }
}
