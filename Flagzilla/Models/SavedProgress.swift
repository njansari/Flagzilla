//
//  SavedProgress.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 13/10/2021.
//

import Foundation

struct SavedProgress: Codable, Identifiable {
    let date: Date
    let score: Int
    let numberOfQuestions: Int
    let continents: Continents

    var id: Date {
        date
    }

    var dateLabel: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    var percentageScore: Double {
        let percent = Double(score) / Double(numberOfQuestions)
        return (percent * 100).rounded(.down) / 100
    }
}

extension SavedProgress {
    static private var fileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("LearnProgress").appendingPathExtension(for: .data)
    }

    static func loadSavedProgress() -> [SavedProgress] {
        guard let data = try? Data(contentsOf: fileUrl),
              let savedProgress = try? JSONDecoder().decode([SavedProgress].self, from: data)
        else {
            return []
        }

        return savedProgress
    }

    static func saveProgress(_ progress: [SavedProgress]) {
        guard let data = try? JSONEncoder().encode(progress) else {
            return
        }

        try? data.write(to: fileUrl)
    }
}
