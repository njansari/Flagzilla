//
//  FlagsMapView.swift
//  FlagsMapView
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit
import SwiftUI

struct FlagsMapView: View {
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

    @Environment(\.dismiss) private var dismiss

    @AppStorage("mapType") private var mapType: MapType = .standard

    @State private var filterContinent: Continents = {
        let value = UserDefaults.standard.value(forKey: "mapFilterContinent") as? Int ?? Continents.all.rawValue
        return Continents(rawValue: value)
    }()

    var annotations: [MKAnnotation] {
        var countries: [Country] = Bundle.main.decodeJSON(from: "countries")

        if filterContinent != .all {
            countries = countries.filter { $0.continents.isSuperset(of: filterContinent) }
        }

        return countries.map(FlagAnnotation.init)
    }

    var doneButton: some View {
        Button("Done", action: dismiss.callAsFunction)
            .padding(10)
            .background(.tertiaryGroupedBackground, in: RoundedRectangle(cornerRadius: 10))
    }

    var mapTypeFilterMenu: some View {
        Menu {
            Picker("Map Type", selection: $mapType) {
                ForEach(MapType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
        } label: {
            Label("Change continent", systemImage: "globe")
                .imageScale(.large)
        }
        .padding(10)
    }

    var continentFilterMenu: some View {
        Menu {
            Picker("Filter Continents", selection: $filterContinent.animation()) {
                Text("All")
                    .tag(Continents.all)

                Divider()

                ForEach(Continent.allCases, id: \.self) { continent in
                    Text(continent.rawValue)
                        .tag(Continents([continent]))
                }
            }
        } label: {
            Label("Filter countries by continent", systemImage: "line.3.horizontal.decrease.circle")
                .imageScale(.large)
                .symbolVariant(filterContinent == .all ? .none : .fill)
        }
        .padding(10)
    }

    var flagFilters: some View {
        VStack(spacing: 0) {
            mapTypeFilterMenu

            Divider()
                .frame(width: 48)
                .background(.secondary)

            continentFilterMenu
                .onChange(of: filterContinent) { newFilter in
                    UserDefaults.standard.set(newFilter.rawValue, forKey: "mapFilterContinent")
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .background(.tertiaryGroupedBackground, in: RoundedRectangle(cornerRadius: 10))
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Group {
                        MapView(mapType: mapType.mkType, annotations: annotations)

                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(height: geometry.safeAreaInsets.top)
                    }
                    .ignoresSafeArea()

                    HStack(alignment: .top) {
                        doneButton

                        Spacer()

                        flagFilters
                    }
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .labelStyle(.iconOnly)
                    .shadow(color: Color(white: 0, opacity: 0.15), radius: 8)
                    .padding(10)
                }
            }
            .navigationTitle("Map")
            .navigationBarHidden(true)
        }
    }
}

struct FlagsMapView_Previews: PreviewProvider {
    static var previews: some View {
        FlagsMapView()
    }
}
