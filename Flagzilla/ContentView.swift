//
//  ContentView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 27/08/2021.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedTab") private var selectedTab: Tab = .flags

    @State private var showingMap = false

    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGroupedBackground
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .systemGroupedBackground

        UITabBar.appearance().standardAppearance = tabBarAppearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            FlagsGridView()
                .tabItem {
                    Tab.flags.tabItem
                }
                .tag(Tab.flags)

            Text("")
                .tabItem {
                    Tab.map.tabItem
                }
                .tag(Tab.map)
                .fullScreenCover(isPresented: $showingMap, content: FlagsMapView.init)

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
        .onChange(of: selectedTab) { [selectedTab] newTab in
            tabChanged(from: selectedTab, to: newTab)
        }
    }

    func tabChanged(from oldTab: Tab, to newTab: Tab) {
        if newTab == .map {
            self.selectedTab = oldTab
            showingMap = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
