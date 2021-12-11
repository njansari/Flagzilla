//
//  FlagDelegate.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 29/11/2021.
//

import Foundation

class FlagDelegate: ObservableObject {
    @Published var country: Country?
    @Published var clusterCount = 0
}
