//
//  FlagView.swift
//  FlagView
//
//  Created by Nayan Jansari on 31/08/2021.
//

import SwiftUI
import MapKit

struct FlagView: View {
    @ObservedObject private(set) var delegate: FlagDelegate

    static let flagSize = CGSize(width: 48, height: 36)
    static let flagOnPoleSize = CGSize(width: 54, height: 58)

    private var isCluster: Bool {
        delegate.clusterCount != 0
    }

    private var flagImageUrl: URL? {
        delegate.country?.wavingFlag
    }

    private var flagTransition: AnyTransition {
        isCluster ? .opacity : .opacity.combined(with: .move(edge: .bottom))
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
        AsyncFlagImage(url: flagImageUrl, animation: .easeOut) { image in
            ZStack {
                image
                    .brightness(isCluster ? -0.2 : 0)

                if isCluster {
                    Image(systemName: "\(delegate.clusterCount).circle")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .shadow(radius: 1)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .transition(flagTransition)
        } placeholder: {
            Color.clear
                .frame(width: Self.flagSize.width, height: Self.flagSize.height)
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: -4) {
            if !isCluster {
                pole
            }

            if delegate.country != nil {
                flag
                    .offset(y: isCluster ? 0 : 5)
                    .zIndex(-1)
            }
        }
        .drawingGroup()
    }
}

struct FlagView_Previews: PreviewProvider {
    @StateObject static private var flagDelegate: FlagDelegate = {
        let delegate = FlagDelegate()
        delegate.country = .example
        delegate.clusterCount = 0

        return delegate
    }()

    static var previews: some View {
        FlagView(delegate: flagDelegate)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
