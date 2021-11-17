//
//  ContinentsFilterView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 19/09/2021.
//

import SwiftUI

struct ContinentsFilterView: View {
    @EnvironmentObject private var settings: LearnSettings

    var body: some View {
        Section {
            ForEach(Continent.allCases.sorted(), id: \.self) { continent in
                HStack {
                    Text(continent.rawValue)

                    Spacer()

                    Button {
                        if settings.continents.contains(continent) {
                            if settings.continents.count > 1 {
                                settings.continents.remove(continent)
                            }
                        } else {
                            settings.continents.insert(continent)
                        }
                    } label: {
                        if settings.continents.contains(continent) {
                            Image.checkmark
                        }
                    }
                }
            }
        } header: {
            HStack(alignment: .lastTextBaseline) {
                Text("Continents")

                Spacer()

                if settings.continents != .all {
                    Button("Select All") {
                        settings.continents = .all
                    }
                    .disabled(settings.continents == .all)
                }
            }
        } footer: {
            Text("These are the continents.")
        }
    }
}

struct ContinentsFilterView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ContinentsFilterView()
        }
        .environmentObject(LearnSettings())
    }
}
