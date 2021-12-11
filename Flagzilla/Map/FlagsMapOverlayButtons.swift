//
//  FlagsMapOverlayButtons.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 05/12/2021.
//

import SwiftUI

struct FlagsMapOverlayButtons: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("mapType") private var mapType: MapType = .standard
    @AppStorage("mapFilterContinent") private var filterContinent: Continents = .all

    private let buttonCornerRadius = 10.0

    private var doneButton: some View {
        Button("Done", action: dismiss.callAsFunction)
            .padding(10)
            .background(.tertiaryGroupedBackground, in: RoundedRectangle(cornerRadius: buttonCornerRadius))
    }

    private var mapTypeFilterMenu: some View {
        Menu {
            Picker("Map Type", selection: $mapType) {
                ForEach(MapType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
        } label: {
            Label("Change map type", systemImage: "globe")
                .imageScale(.large)
        }
        .padding(10)
    }

    private var continentFilterMenu: some View {
        Menu {
            Picker("Filter Continents", selection: $filterContinent.animation()) {
                Text("All")
                    .tag(Continents.all)

                Divider()

                ForEach(Continent.allCases, id: \.self) { continent in
                    Text(continent.rawValue)
                        .tag(Continents([continent]))
                }
            }
        } label: {
            Label("Filter countries by continent", systemImage: "line.3.horizontal.decrease.circle")
                .imageScale(.large)
                .symbolVariant(filterContinent == .all ? .none : .fill)
        }
        .padding(10)
    }

    private var flagFilters: some View {
        VStack(spacing: 0) {
            mapTypeFilterMenu

            Divider()
                .frame(width: 48)
                .background(.secondary)

            continentFilterMenu
        }
        .background(.tertiaryGroupedBackground)
        .cornerRadius(buttonCornerRadius)
    }

    var body: some View {
        HStack(alignment: .top) {
            doneButton

            Spacer()

            flagFilters
        }
        .font(.headline)
        .foregroundStyle(.secondary)
        .labelStyle(.iconOnly)
        .shadow(color: .init(white: 0, opacity: 0.15), radius: 8)
        .padding(10)
    }
}

struct FlagsMapOverlayButtons_Previews: PreviewProvider {
    static var previews: some View {
        FlagsMapOverlayButtons()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
