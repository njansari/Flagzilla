//
//  FlagView.swift
//  FlagView
//
//  Created by Nayan Jansari on 31/08/2021.
//

import SwiftUI

// The actual flag annotation view that shows the country's flag
// dependent on the configuration provided by the system's map view.
struct FlagView: View {
    @ObservedObject private(set) var config: MapFlagConfiguration

    // Constant properties that store the various sizes of the flag
    // used to determine its position on the map. These values won't change
    // so there is no dynamic size and position calculation.
    static let flagSize = CGSize(width: 48, height: 36)
    static let flagOnPoleSize = CGSize(width: 54, height: 58)

    // When the flag has been fetched from the internet, and if the annotation is just for one flag,
    // the flag should animate on screen as if it were being raised on a pole.
    private var flagTransition: AnyTransition {
        config.isCluster ? .opacity : .opacity.combined(with: .move(edge: .bottom))
    }

    private var pole: some View {
        VStack(spacing: -2) {
            Circle()
                .fill(.conicGradient(colors: [.yellow, .brown, .yellow], center: .center, angle: .radians(.pi / -2)))
                .frame(width: 10, height: 10)
                .zIndex(1)

            RoundedCornerRectangle([.bottomLeft, .bottomRight], cornerRadius: 2.5)
                .fill(.ellipticalGradient(colors: [.white, .gray], endRadiusFraction: 0.6))
                .frame(width: 5, height: 50)
        }
    }

    private var flag: some View {
        AsyncFlagImage(url: config.country?.wavingFlag, animation: .easeOut) { image in
            image
                .brightness(config.isCluster ? -0.2 : 0)
                .overlay {
                    if config.isCluster {
                        Image(systemName: "\(config.clusterCount).circle.fill")
                            .font(.title2.bold())
                            .background(.thickMaterial, in: Circle())
                    }
                }
                .transition(flagTransition)
        } placeholder: {
            Color.clear
                .frame(size: Self.flagSize)
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: -4) {
            if !config.isCluster {
                pole
            }

            if config.country != nil {
                flag
                    .offset(y: config.isCluster ? 0 : 5)
                    .zIndex(-1)
            }
        }
        .drawingGroup()
    }
}

struct FlagView_Previews: PreviewProvider {
    @StateObject static private var flagConfig: MapFlagConfiguration = {
        let config = MapFlagConfiguration()
        config.country = .example
        config.clusterCount = 0

        return config
    }()

    static var previews: some View {
        FlagView(config: flagConfig)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
