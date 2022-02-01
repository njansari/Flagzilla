//
//  CountryView.swift
//  CountryView
//
//  Created by Nayan Jansari on 05/09/2021.
//

import SwiftUI

// This is the detail view that shows when the user selects a flag in the scrolling grid.
// Information about the country is shown alongside a larger image of its flag.
struct CountryView: View {
    let country: Country

    // This string is looked up in the localised strings dictionary file
    // and determines whether the word `city` should be pluralised or not.
    private var capitalsLabel: LocalizedStringKey {
        "Capitals \(country.capitalCities.count)" // Would become `Capital city(ies)`.
    }

    // This string is looked up in the localised strings dictionary file
    // and determines whether the word `continent` should be pluralised or not.
    private var continentsLabel: LocalizedStringKey {
        "Continents \(country.continents.count)"  // Would become `Continent(s)`.
    }

    private var flagImage: some View {
        AsyncFlagImage(url: country.largeFlag, animation: .easeOut) { image in
            image
                .resizable()
                .scaledToFit()
                .shadow(color: .primary.opacity(0.4), radius: 5)
                .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .bottom)))
        } placeholder: {
            Rectangle()
                .fill(.quaternary)
                .blur(radius: 20)
                .frame(height: 200)
                .transition(.opacity)
        }
    }

    private var countryHeader: some View {
        VStack(spacing: 18) {
            flagImage

            Text(country.officialName)
                .multilineTextAlignment(.center)
        }
        .infiniteMaxWidth()
    }

    var body: some View {
        List {
            Section {
                InformationRowView(label: capitalsLabel, content: country.capitalCities.formatted())
                InformationRowView(label: continentsLabel, content: country.continents.formatted())
                InformationRowView(label: "Country code", content: country.id.uppercased())
                InformationRowView(label: "Coordinates", content: country.coordinates.formatted())
            } header: {
                countryHeader
            }
            .headerProminence(.increased)
            .textSelection(.enabled)
        }
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CountryView(country: .example)
        }
    }
}
