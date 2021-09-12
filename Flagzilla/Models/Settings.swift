//
//  Settings.swift
//  Settings
//
//  Created by Nayan Jansari on 07/09/2021.
//

import MapKit
import SwiftUI

@MainActor class Settings: ObservableObject {
    enum MapType: String, CaseIterable {
        case standard = "Standard"
        case hybrid = "Hybrid"
        case satellite = "Satellite"

        var mapType: MKMapType {
            switch self {
                case .standard: return .standard
                case .hybrid: return .hybrid
                case .satellite: return .satellite
            }
        }
    }

    @AppStorage("mapType") var mapType: MapType = .standard
}
