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

    private var capitalsLabel: LocalizedStringKey {
        "Capitals \(country.capitalCities.count)"
    }

    private var continentsLabel: LocalizedStringKey {
        "Continents \(country.continents.count)"
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
        .frame(maxWidth: .infinity)
    }

    var body: some View {
        Form {
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
