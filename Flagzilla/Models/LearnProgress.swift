//
//  LearnProgress.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/10/2021.
//

import Foundation

@MainActor class LearnProgress: ObservableObject {
    @Published var questionNumber = 1
    @Published var score = 0
}
