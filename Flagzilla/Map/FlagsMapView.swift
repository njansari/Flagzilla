//
//  FlagsMapView.swift
//  FlagsMapView
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit
import SwiftUI

struct FlagsMapView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var filterContinent: Continent?

    let mapType: MKMapType

    var annotations: [MKAnnotation] {
        var countries: [Country] = Bundle.main.decodeJSON(from: "countries")

        if let filterContinent = filterContinent {
            countries = countries.filter { $0.continents.contains(filterContinent.rawValue) }
        }

        return countries.map(FlagAnnotation.init)
    }

    var statusBarHeight: CGFloat {
        let window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow }
        return window?.safeAreaInsets.top ?? 0
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .top) {
                    MapView(mapType: mapType, annotations: annotations)

                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(height: statusBarHeight)

                }
                .navigationTitle("Map")
                .navigationBarHidden(true)
                .ignoresSafeArea()

                HStack {
                    Button(action: dismiss.callAsFunction) {
                        Text("Done")
                            .font(.headline)
                            .padding(2)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))

                    Spacer()

                    Menu {
                        Picker("Filter Continents", selection: $filterContinent) {
                            Text("All")
                                .tag(nil as Continent?)

                            Divider()

                            ForEach(Continent.allCases, id: \.self) { continent in
                                Text(continent.rawValue)
                                    .tag(continent as Continent?)
                            }
                        }
                    } label: {
                        Button(action: {}) {
                            Label("Change continent", systemImage: "globe")
                                .imageScale(.large)
                                .labelStyle(.iconOnly)
                        }
                        .font(.headline)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 10))
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .controlSize(.regular)
                .padding(10)
            }
        }
    }
}

struct FlagsMapView_Previews: PreviewProvider {
    static var previews: some View {
        FlagsMapView(mapType: .standard)
    }
}
