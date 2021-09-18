//
//  CountriesView.swift
//  CountriesView
//
//  Created by Nayan Jansari on 30/08/2021.
//

import SwiftUI

struct CountriesView: View {
    @State private var filterContinent: Continents = .all
    @State private var searchText = ""

    let columns = [GridItem(.adaptive(minimum: 320 / 3))]

    var filteredCountries: [Country] {
        countries.filter { country in
            var shouldInclude = true

            if !searchText.isEmpty {
                let searchParameters: [KeyPath<Country, String>] = [\.name, \.officialName, \.id]

                let containsSearch = searchParameters.map {
                    country[keyPath: $0].localizedCaseInsensitiveContains(searchText)
                }

                shouldInclude = containsSearch.contains(true)
            }

            if filterContinent != .all {
                shouldInclude = shouldInclude && country.continents.isSuperset(of: filterContinent)
            }

            return shouldInclude
        }.sorted { $0.name < $1.name }
    }

    var navigationTitle: String {
        filterContinent == .all ? "All Countries" : filterContinent.formatted()
    }

    var filterMenu: some View {
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

    var body: some View {
        NavigationView {
            ScrollView {
                Text("\(filteredCountries.count) countries")
                    .font(.callout.weight(.medium))
                    .animation(nil, value: filterContinent)

                LazyVGrid(columns: columns, spacing: 12, pinnedViews: .sectionHeaders) {
                    ForEach(filteredCountries, content: FlagGridItem.init)
                }
                .padding(.horizontal)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .navigationTitle(navigationTitle)
            .background(.groupedBackground)
            .toolbar {
                filterMenu
            }
        }
    }
}

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}
