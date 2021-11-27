//
//  FlagAnnotation.swift
//  FlagAnnotation
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit

class FlagAnnotation: NSObject, MKAnnotation {
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
        if title == country.officialName {
            return nil
        } else {
            return country.officialName
        }
    }
}
