//
//  ContentView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 27/08/2021.
//

import SwiftUI

let countries: [Country] = Bundle.main.decodeJSON(from: "countries")

enum Tab: String {
    case flags
    case map
    case classifier
    case learn

    var tabItem: some View {
        switch self {
            case .flags: return Label("Flags", systemImage: "flag.filled.and.flag.crossed")
            case .map: return Label("Map", systemImage: "map")
            case .classifier: return Label("Classifier", systemImage: "viewfinder")
            case .learn: return Label("Learn", systemImage: "brain")
        }
    }
}

struct ContentView: View {
    @SceneStorage("selectedTab") private var selectedTab: Tab = .flags

    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGroupedBackground
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .systemGroupedBackground

        UITabBar.appearance().standardAppearance = tabBarAppearance

        UIPageControl.appearance().currentPageIndicatorTintColor = .tintColor
        UIPageControl.appearance().pageIndicatorTintColor = .tertiaryLabel
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            FlagsGridView()
                .tabItem {
                    Tab.flags.tabItem
                }
                .tag(Tab.flags)

            MapSettingsView()
                .tabItem {
                    Tab.map.tabItem
                }
                .tag(Tab.map)

            FlagClassifierView()
                .tabItem {
                    Tab.classifier.tabItem
                }
                .tag(Tab.classifier)

            LearnView()
                .tabItem {
                    Tab.learn.tabItem
                }
                .tag(Tab.learn)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
