//
//  ContentView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 27/08/2021.
//

import SwiftUI

let countries: [Country] = Bundle.main.decodeJSON(from: "countries")

enum Tab: String {
    case countries
    case map
    case classifier
    case learn

    var tabItem: some View {
        switch self {
            case .countries: return Label("Countries", systemImage: "flag")
            case .map: return Label("Map", systemImage: "map")
            case .classifier: return Label("Classifier", systemImage: "viewfinder")
            case .learn: return Label("Learn", systemImage: "brain")
        }
    }
}

struct ContentView: View {
    @SceneStorage("selectedTab") private var selectedTab: Tab?

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]

        UIPageControl.appearance().currentPageIndicatorTintColor = .tintColor
        UIPageControl.appearance().pageIndicatorTintColor = .tertiaryLabel
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            CountriesView()
                .tabItem {
                    Tab.countries.tabItem
                }
                .tag(Tab.countries.rawValue)

            MapSettingsView()
                .tabItem {
                    Tab.map.tabItem
                }
                .tag(Tab.map.rawValue)

            FlagClassifierView()
                .tabItem {
                    Tab.classifier.tabItem
                }
                .tag(Tab.classifier.rawValue)

            LearnView()
                .tabItem {
                    Tab.learn.tabItem
                }
                .tag(Tab.learn.rawValue)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
