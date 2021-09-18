//
//  Continents.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 18/09/2021.
//

import Foundation

protocol Option: CaseIterable, Hashable, RawRepresentable {}

enum Continent: String, Decodable, Option {
    case asia = "Asia"
    case africa = "Africa"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case europe = "Europe"
    case oceania = "Oceania"
    case antarctica = "Antarctica"
}

typealias Continents = Set<Continent>

extension Set where Element == Continent {
    static var all: Continents {
        Set(Continent.allCases)
    }

    func formatted() -> String {
        map(\.rawValue).sorted().formatted()
    }
}

extension Set where Element: Option {
    var rawValue: Int {
        var rawValue = 0

        for (index, element) in Element.allCases.enumerated() where contains(element) {
            rawValue |= 1 << index
        }

        return rawValue
    }
}
