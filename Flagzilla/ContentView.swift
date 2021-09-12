//
//  ContentView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 27/08/2021.
//

import SwiftUI

let countries: [Country] = Bundle.main.decodeJSON(from: "countries")

struct ContentView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]

        UIPageControl.appearance().currentPageIndicatorTintColor = .tintColor
        UIPageControl.appearance().pageIndicatorTintColor = .tertiaryLabel
    }

    var body: some View {
        TabView {
            CountriesView()
                .tabItem {
                    Label("Countries", systemImage: "flag")
                }

            MapSettingsView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            ConverterView()
                .tabItem {
                    Label("Converter", systemImage: "arrow.triangle.2.circlepath")
                }

            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "brain")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Settings())
    }
}
