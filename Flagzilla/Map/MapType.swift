//
//  MapType.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 05/12/2021.
//

import MapKit

enum MapType: String, CaseIterable {
    case standard = "Standard"
    case hybrid = "Hybrid"
    case satellite = "Satellite"

    var mkType: MKMapType {
        switch self {
        case .standard: return .standard
        case .hybrid: return .hybrid
        case .satellite: return .satellite
        }
    }
}
