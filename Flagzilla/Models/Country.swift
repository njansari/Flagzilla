//
//  Country.swift
//  Country
//
//  Created by Nayan Jansari on 27/08/2021.
//

import MapKit

let countries: Set<Country> = Bundle.main.decodeJSON(from: "countries")

struct Country: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
    let officialName: String
    let capitalCities: [String]
    let continents: Continents
    let coordinates: Coordinate

    var gridFlag: URL? {
        URL(string: "https://flagcdn.com/w320/\(id).png")
    }

    var detailFlag: URL? {
        URL(string: "https://flagcdn.com/w1280/\(id).png")
    }

    var mapFlag: URL? {
        URL(string: "https://flagcdn.com/144x108/\(id).png")
    }

    static let example = countries.randomElement()!

    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
