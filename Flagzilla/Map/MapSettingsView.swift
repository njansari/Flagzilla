//
//  MapSettingsView.swift
//  MapSettingsView
//
//  Created by Nayan Jansari on 05/09/2021.
//

import MapKit
import SwiftUI

struct MapSettingsView: View {
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

    @State private var showingMap = false

    var body: some View {
        NavigationView {
            Form {
                Picker("Map Type", selection: $mapType) {
                    ForEach(MapType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(.inline)

                Button("Show Map") {
                    showingMap = true
                }
                .buttonStyle(.listRow)
                .fullScreenCover(isPresented: $showingMap) {
                    FlagsMapView(mapType: mapType.mapType)
                }
            }
            .navigationTitle("Map")
        }
    }
}

struct MapSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MapSettingsView()
    }
}
