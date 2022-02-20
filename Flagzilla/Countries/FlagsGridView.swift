//
//  FlagsGridView.swift
//  FlagsGridView
//
//  Created by Nayan Jansari on 30/08/2021.
//

import SwiftUI

// This is first tab, responsible for showing the world flags browser.
struct FlagsGridView: View {
    @AppStorage("filterContinent") private var filterContinent: Continents = .all

    @State private var searchText = ""
    @State private var showingCountryNames = true

    // The column width for the scrolling grid is defined by the width of the individual flags.
    private let gridColumns = [GridItem(.adaptive(minimum: 320 / 3))]

    private var filteredCountries: [Country] {
        countries.filter { country in
            var shouldInclude = true

            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

            // Check if the search text contains any of the country's name properties.
            if !trimmedSearchText.isEmpty {
                let searchParameters = [\Country.name, \Country.officialName, \Country.id]

                let containsSearch = searchParameters.map {
                    country[keyPath: $0].localizedCaseInsensitiveContains(trimmedSearchText)
                }

                shouldInclude = containsSearch.contains(true)
            }

            // Check if the country satisfies the current continents filter.
            if filterContinent != .all {
                shouldInclude = shouldInclude && country.continents.isSuperset(of: filterContinent)
            }

            return shouldInclude
        }.sorted(by: \.name)
    }

    // The title for this view is determined by the current continent filter.
    private var navigationTitle: String {
        filterContinent == .all ? "All Countries" : filterContinent.formatted()
    }

    private var filterMenu: some View {
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
                .symbolVariant(filterContinent == .all ? .none : .fill)
        }
    }

    private var countryNameLabelToggle: some View {
        Toggle(isOn: $showingCountryNames.animation()) {
            Label("Show labels", image: "text.below.rectangle")
        }
    }

    // The number of countries visible in the grid is shown to the user
    // relaying the effect of any operational filters.
    private var countriesCountText: some View {
        Text("\(filteredCountries.count) countries")
            .font(.callout.weight(.medium))
            .animation(nil, value: filterContinent)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                countriesCountText

                LazyVGrid(columns: gridColumns, spacing: 12) {
                    ForEach(filteredCountries) { country in
                        FlagGridItem(country: country, showsName: showingCountryNames)
                    }
                }
                .padding([.horizontal, .bottom])
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .navigationTitle(navigationTitle)
            .background(.groupedBackground)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    countryNameLabelToggle
                    filterMenu
                }
            }
        }
    }
}

struct FlagsGridView_Previews: PreviewProvider {
    static var previews: some View {
        FlagsGridView()
    }
}
