//
//  Tab.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 09/10/2021.
//

import SwiftUI

enum Tab: String {
    case flags
    case map
    case classifier
    case learn

    var tabItem: some View {
        switch self {
            case .flags: return Label("Flags", systemImage: "flag.2.crossed")
            case .map: return Label("Map", systemImage: "map")
            case .classifier: return Label("Classifier", image: "flag.viewfinder")
            case .learn: return Label("Learn", systemImage: "brain")
        }
    }
}
