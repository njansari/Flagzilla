//
//  Continents.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 18/09/2021.
//

import Foundation

protocol Option: CaseIterable, Hashable {}

enum Continent: String, Codable, Comparable, Option {
    case asia = "Asia"
    case africa = "Africa"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case europe = "Europe"
    case oceania = "Oceania"
    case antarctica = "Antarctica"

    static func < (lhs: Continent, rhs: Continent) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
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
    init(rawValue: Int) {
        var result: Set<Element> = []

        for (index, element) in Element.allCases.enumerated() {
            let value = rawValue >> index

            if value == value | 1 {
                result.insert(element)
            }
        }

        self = result
    }

    var rawValue: Int {
        var rawValue = 0

        for (index, element) in Element.allCases.enumerated() where contains(element) {
            rawValue |= 1 << index
        }

        return rawValue
    }

    func isSupersetOrSubset(of other: Set<Element>) -> Bool {
        isSuperset(of: other) || isSubset(of: other)
    }
}
