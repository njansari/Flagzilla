//
//  MapFlagConfiguration.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 29/11/2021.
//

import Foundation

// Controls what country an individual map annotation view displays
// and whether it is responsible for multiple flags.
final class MapFlagConfiguration: ObservableObject {
    @Published var country: Country?
    @Published var clusterCount = 0

    var isCluster: Bool {
        clusterCount != 0
    }
}
