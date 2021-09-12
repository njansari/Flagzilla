//
//  Country.swift
//  Country
//
//  Created by Nayan Jansari on 27/08/2021.
//

import MapKit

struct Country: Decodable, Identifiable {
    let id: String
    let name: String
    let officialName: String
    let continents: [String]
    let coordinates: CLLocationCoordinate2D
//    let flagDescription: String

    var gridFlag: URL? {
        URL(string: "https://flagcdn.com/w320/\(id).png")
    }

    var detailFlag: URL? {
        URL(string: "https://flagcdn.com/w1280/\(id).png")
    }

    var mapFlag: URL? {
        URL(string: "https://flagcdn.com/144x108/\(id).png")
    }

    static let example = countries[183]
}

enum Continent: String, CaseIterable, Decodable {
    case asia = "Asia"
    case africa = "Africa"
    case antarctica = "Antarctica"
    case europe = "Europe"
    case northAmerica = "North America"
    case oceania = "Oceania"
    case southAmerica = "South America"
}
