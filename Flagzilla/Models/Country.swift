//
//  Country.swift
//  Country
//
//  Created by Nayan Jansari on 27/08/2021.
//

import CoreLocation

let countries: Set<Country> = Bundle.main.decodeJSON(from: "countries")

struct Country: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
    let officialName: String
    let capitalCities: [String]
    let continents: Continents
    let coordinates: Coordinate

    var officialNameIsName: Bool {
        name == officialName
    }

    var largeFlag: URL? {
        URL(string: "https://flagcdn.com/w1280/\(id).png")
    }

    var mediumFlag: URL? {
        URL(string: "https://flagcdn.com/w320/\(id).png")
    }

    var smallFlag: URL? {
        URL(string: "https://flagcdn.com/h240/\(id).png")
    }

    var miniFlag: URL? {
        URL(string: "https://flagcdn.com/h160/\(id).png")
    }

    var wavingFlag: URL? {
        URL(string: "https://flagcdn.com/144x108/\(id).png")
    }

    static var example: Country {
        countries.randomElement()!
    }

    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
