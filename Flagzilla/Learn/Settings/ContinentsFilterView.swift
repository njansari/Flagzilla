//
//  ContinentsFilterView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 19/09/2021.
//

import SwiftUI

struct ContinentsFilterView: View {
    @EnvironmentObject private var settings: LearnSettings

    private var continentsList: some View {
        ForEach(Continent.allCases.sorted(), id: \.self) { continent in
            HStack {
                Text(continent.rawValue)

                Spacer()

                Button {
                    toggleSelection(of: continent)
                } label: {
                    if settings.continents.contains(continent) {
                        Image.checkmark
                    }
                }
            }
            .accessibilityElement()
            .accessibilityLabel(continent.rawValue)
            .accessibilityAddTraits(settings.continents.contains(continent) ? .isSelected : [])
        }
    }

    private var header: some View {
        HStack(alignment: .lastTextBaseline) {
            Text("Continents")

            Spacer()

            if settings.continents != .all {
                Button("Select All") {
                    settings.continents = .all
                }
                .disabled(settings.continents == .all)
            }
        }
    }

    var body: some View {
        Section {
            continentsList
        } header: {
            header
        } footer: {
            Text("The flags in the questions and answer options will be selected from these continents.")
        }
    }

    private func toggleSelection(of continent: Continent) {
        if settings.continents.contains(continent) {
            if settings.continents.count > 1 {
                settings.continents.remove(continent)
            }
        } else {
            settings.continents.insert(continent)
        }
    }
}

struct ContinentsFilterView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ContinentsFilterView()
        }
        .environmentObject(LearnSettings())
    }
}
