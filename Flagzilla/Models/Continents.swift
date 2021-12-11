//
//  Continents.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 18/09/2021.
//

import Foundation

enum Continent: String, CaseIterable, Codable, Comparable {
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

extension Continents: RawRepresentable {
    public init(rawValue: Int) {
        var result = Self()

        for (index, element) in Element.allCases.enumerated() {
            let value = rawValue >> index

            if value == value | 1 {
                result.insert(element)
            }
        }

        self = result
    }

    public var rawValue: Int {
        var rawValue = 0

        for (index, element) in Element.allCases.enumerated() where contains(element) {
            rawValue |= 1 << index
        }

        return rawValue
    }

    static var all: Continents {
        Set(Continent.allCases)
    }

    func formatted() -> String {
        map(\.rawValue).sorted().formatted()
    }

    func isSupersetOrSubset(of other: Self) -> Bool {
        isSuperset(of: other) || isSubset(of: other)
    }
}
