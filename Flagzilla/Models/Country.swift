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
    let continents: Continents
    let coordinates: Coordinate
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
