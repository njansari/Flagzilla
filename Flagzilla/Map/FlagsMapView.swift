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

        var mapType: MKMapType {
            switch self {
                case .standard: return .standard
                case .hybrid: return .hybrid
                case .satellite: return .satellite
            }
        }
    }

    @Environment(\.dismiss) private var dismiss

    @AppStorage("mapType") var mapType: MapType = .standard

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

    var statusBarHeight: CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        return window?.safeAreaInsets.top ?? 0
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .top) {
                    MapView(mapType: mapType.mapType, annotations: annotations)

                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(height: statusBarHeight)

                }
                .navigationTitle("Map")
                .navigationBarHidden(true)
                .ignoresSafeArea()

                HStack(alignment: .top) {
                    Button(action: dismiss.callAsFunction) {
                        Text("Done")
                            .frame(minWidth: 44, minHeight: 28)
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))

                    Spacer()

                    VStack(spacing: 0) {
                        Menu {
                            Picker("Map Type", selection: $mapType) {
                                ForEach(MapType.allCases, id: \.self) { type in
                                    Text(type.rawValue)
                                }
                            }
                        } label: {
                            Button(action: {}) {
                                Label("Change continent", systemImage: "globe")
                                    .imageScale(.large)
                            }
                        }

                        Divider()
                            .frame(width: 51)

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
                            Button(action: {}) {
                                Label("Filter countries by continent", systemImage: "line.3.horizontal.decrease.circle")
                                    .imageScale(.large)
                                    .symbolVariant(filterContinent == .all ? .none : .fill)
                            }
                        }
                        .onChange(of: filterContinent) { newFilter in
                            UserDefaults.standard.set(newFilter.rawValue, forKey: "mapFilterContinent")
                        }
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 0))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))
                }
                .font(.headline)
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                .padding(10)
            }
        }
    }
}

struct FlagsMapView_Previews: PreviewProvider {
    static var previews: some View {
        FlagsMapView()
    }
}
