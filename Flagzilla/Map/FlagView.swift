//
//  FlagView.swift
//  FlagView
//
//  Created by Nayan Jansari on 31/08/2021.
//

import SwiftUI

@MainActor class FlagDelegate: ObservableObject {
    @Published var country: Country?
    @Published var clusterCount = 0
    @Published var isSelected: Bool? = false
}

struct FlagView: View {
    @ObservedObject var delegate: FlagDelegate
    
    var isCluster: Bool {
        delegate.clusterCount != 0
    }

    var flagImageUrl: URL? {
        if let country = delegate.country {
            return country.mapFlag
        } else {
            return nil
        }
    }

    var flagTransition: AnyTransition {
        if isCluster {
            return .opacity
        } else {
            return .opacity.combined(with: .move(edge: .bottom))
        }
    }

    var pole: some View {
        VStack(spacing: -2) {
            Circle()
                .fill(.conicGradient(colors: [.yellow, .brown, .yellow], center: .center, angle: .radians(.pi / -2)))
                .frame(width: 10, height: 10)
                .zIndex(1)
                .shadow(radius: 0.5, y: 1)

            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(.linearGradient(colors: [.gray, .white, .gray], startPoint: .leading, endPoint: .trailing))
                .frame(width: 5, height: 50)
                .shadow(radius: 0.5, y: 2)
        }
    }

    var flag: some View {
        AsyncImage(url: flagImageUrl, scale: 3, transaction: Transaction(animation: .easeOut)) { phase in
            if let image = phase.image {
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
            } else {
                Color.clear
                    .frame(width: 48, height: 36)
            }
        }
    }

    var body: some View {
        NavigationLink(tag: true, selection: $delegate.isSelected) {
            CountryView(country: delegate.country ?? .example)
        } label: {
            HStack(alignment: .top, spacing: -4) {
                if !isCluster {
                    pole
                }

                if delegate.country != nil {
                    flag
                        .offset(y: 5)
                        .zIndex(-1)
                }
            }
            .shadow(radius: 20, y: 40)
        }
    }
}

struct FlagPole_Previews: PreviewProvider {
    @StateObject static private var flagDelegate: FlagDelegate = {
        let delegate = FlagDelegate()
        delegate.country = .example
        delegate.clusterCount = 0

        return delegate
    }()

    static var previews: some View {
        FlagView(delegate: flagDelegate)
            .frame(minWidth: 56, minHeight: 40, alignment: .leading)
            .previewLayout(.fixed(width: 50, height: 40))
    }
}
