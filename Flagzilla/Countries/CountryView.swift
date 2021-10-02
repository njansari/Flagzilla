//
//  CountryView.swift
//  CountryView
//
//  Created by Nayan Jansari on 05/09/2021.
//

import SwiftUI

struct CountryView: View {
    let country: Country

    var flagImage: some View {
        AsyncImage(url: country.detailFlag, scale: 3, transaction: Transaction(animation: .easeOut)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .primary.opacity(0.4), radius: 5)
                    .transition(.opacity)
            } else {
                Color.clear
                    .frame(height: 0)
            }
        }
    }

    var countryHeader: some View {
        VStack(spacing: 15) {
            flagImage

            Text(country.officialName)
                .multilineTextAlignment(.center)
                .animation(nil) // TODO: find alternative
        }
        .frame(maxWidth: .infinity)
    }

    var body: some View {
        Form {
            Section {
                InformationRowView(label: "Capitals \(country.capitalCities.count)", content: country.capitalCities.formatted())

                InformationRowView(label: "Continents \(country.continents.count)", content: country.continents.map(\.rawValue).formatted())

                InformationRowView(label: "Country Code", content: country.id.uppercased())

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
