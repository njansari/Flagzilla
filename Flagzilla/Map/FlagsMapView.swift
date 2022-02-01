//
//  FlagsMapView.swift
//  FlagsMapView
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit
import SwiftUI

// This is the second tab, responsible for showing the world map overlaid with countries' flags.
struct FlagsMapView: View {
    @AppStorage("mapType") private var mapType: MapType = .standard
    @AppStorage("mapFilterContinent") private var filterContinent: Continents = .all

    private var annotations: [FlagAnnotation] {
        var countries: [Country] = Bundle.main.decodeJSON(from: "countries")

        // Check which countries satisfy the current continents filter.
        if filterContinent != .all {
            countries = countries.filter { $0.continents.isSuperset(of: filterContinent) }
        }

        return countries.map(FlagAnnotation.init)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                MapView(mapType: mapType.mkType, annotations: annotations)
                topSafeAreaBlur(height: geometry.safeAreaInsets.top)
            }
            .ignoresSafeArea()
        }
        .overlay(alignment: .top, content: FlagsMapOverlayButtons.init)
    }

    // In the top area of the screen, where the status bar is located,
    // a blur is applied over the map to make the status items more legible.
    private func topSafeAreaBlur(height: Double) -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .frame(height: height)
    }
}

struct FlagsMapView_Previews: PreviewProvider {
    static var previews: some View {
        FlagsMapView()
    }
}
