//
//  FlagAnnotation.swift
//  FlagAnnotation
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit

// A single annotation object used to provide data to the individual map annotations,
// specifying is name and location given a country to work with.
final class FlagAnnotation: NSObject, MKAnnotation {
    let country: Country

    init(country: Country) {
        self.country = country
    }

    var coordinate: Coordinate {
        country.coordinates
    }

    var title: String? {
        country.name
    }

    var subtitle: String? {
        country.officialNameIsName ? nil : country.officialName
    }
}
