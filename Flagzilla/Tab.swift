//
//  Tab.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 09/10/2021.
//

import SwiftUI

// Contains all the possible tab sections that form the app.
enum Tab: Int {
    case flags
    case map
    case classifier
    case learn

    @ViewBuilder var tabItem: some View {
        switch self {
        case .flags:
            Label("Flags", systemImage: "flag.2.crossed")
        case .map:
            Label("Map", systemImage: "map")
        case .classifier:
            // Uses a custom icon image set.
            Label("Classifier", image: "flag.viewfinder")
                .imageScale(.large)
                .font(.system(size: 18).weight(.medium))
        case .learn:
            Label("Learn", systemImage: "brain")
        }
    }
}
