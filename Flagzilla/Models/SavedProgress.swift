//
//  SavedProgress.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 13/10/2021.
//

import Foundation

struct SavedProgress: Codable, Identifiable {
    struct ProgressPerContinent: Codable {
        let continent: Continent
        let score: Int
        let numberOfQuestions: Int
    }

    var id = UUID()

    let progressPerContinent: [ProgressPerContinent]

    static let empty: [SavedProgress] = []

    var continents: Continents {
        Set(progressPerContinent.map(\.continent))
    }

    var score: Int {
        progressPerContinent.map(\.score).reduce(0, +)
    }

    var numberOfQuestions: Int {
        progressPerContinent.map(\.numberOfQuestions).reduce(0, +)
    }
}

extension Array where Element == SavedProgress {
    static private var fileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("LearnProgress").appendingPathExtension(for: .data)
    }

    mutating func loadSaved() {
        if let data = try? Data(contentsOf: Self.fileUrl),
           let savedProgress = try? JSONDecoder().decode(Self.self, from: data) {
            self = savedProgress
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(self) {
            try? data.write(to: Self.fileUrl, options: .atomic)
        }
    }
}
