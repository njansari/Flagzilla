//
//  MapSettingsView.swift
//  MapSettingsView
//
//  Created by Nayan Jansari on 05/09/2021.
//

import MapKit
import SwiftUI

struct MapSettingsView: View {
    @EnvironmentObject private var settings: Settings

    @State private var showingMap = false

    var body: some View {
        NavigationView {
            Form {
                Picker("Map Type", selection: $settings.mapType) {
                    ForEach(Settings.MapType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(.inline)

                Button("Show Map") {
                    showingMap = true
                }
                .buttonStyle(.listRow)
                .fullScreenCover(isPresented: $showingMap) {
                    FlagsMapView(mapType: settings.mapType.mapType)
                }
            }
            .navigationTitle("Map")
        }
    }
}

struct MapSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MapSettingsView()
            .environmentObject(Settings())
    }
}
