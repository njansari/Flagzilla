//
//  ContentView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 27/08/2021.
//

import SwiftUI

// This is the main view that makes the rest of the app accessible via a tab view.
struct ContentView: View {
    // Read and writes the currently selected tab to per-scene storage.
    @SceneStorage("selectedTab") private var selectedTab: Tab = .flags

    @State private var showingMap = false

    init() {
        // Sets a custom navigation bar appearance.
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGroupedBackground
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance

        // Sets a custom tab bar appearance.
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .systemGroupedBackground

        UITabBar.appearance().standardAppearance = tabBarAppearance
    }

    private var flagsTab: some View {
        FlagsGridView()
            .tabItem { Tab.flags.tabItem }
            .tag(Tab.flags)
    }

    private var mapTab: some View {
        ProgressView()
            .tabItem { Tab.map.tabItem }
            .tag(Tab.map)
            .fullScreenCover(isPresented: $showingMap, content: FlagsMapView.init)
    }

    private var classifierTab: some View {
        FlagClassifierView()
            .tabItem { Tab.classifier.tabItem }
            .tag(Tab.classifier)
    }

    private var learnTab: some View {
        LearnView()
            .tabItem { Tab.learn.tabItem }
            .tag(Tab.learn)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            flagsTab
            mapTab
            classifierTab
            learnTab
        }
        .onChange(of: selectedTab) { [selectedTab] newTab in
            tabChanged(from: selectedTab, to: newTab)
        }
    }

    private func tabChanged(from oldTab: Tab, to newTab: Tab) {
        // Switches back to the previously selected tab.
        // When selecting the map tab bar item, it creates an effect of tapping a standard button.
        if newTab == .map {
            selectedTab = oldTab
            showingMap = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
