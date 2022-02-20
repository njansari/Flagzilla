//
//  FlagGridItem.swift
//  FlagGridItem
//
//  Created by Nayan Jansari on 12/09/2021.
//

import SwiftUI

// The individual flags shown in the scrolling grid.
struct FlagGridItem: View {
    // Receive the country whose flag should be retrieved and shown in the grid.
    let country: Country
    let showsName: Bool

    private let cornerRadius = 8.0

    // Uses a random colour as the placeholder for the flag image.
    private var placeholderColor: Color {
        let colors: [Color] = [.blue, .cyan, .green, .indigo, .mint, .orange, .primary, .red, .yellow]
        return colors.randomElement()!.opacity(0.6)
    }

    // If loading the flag image fails, an error icon
    // replaces the placeholder to convey the message to the user.
    private var errorImage: some View {
        Image(systemName: "xmark.octagon")
            .font(.largeTitle)
            .symbolVariant(.fill)
            .foregroundStyle(.red)
    }

    var body: some View {
        NavigationLink {
            CountryView(country: country)
        } label: {
            VStack {
                AsyncFlagImage(url: country.mediumFlag, animation: .spring(), content: imageContent) {
                    placeholderColor
                        .transition(.opacity.combined(with: .scale))
                } error: { _ in
                    errorImage
                }
                .cornerRadius(cornerRadius)
                .frame(width: 110, height: 80, alignment: .bottom)

                if showsName {
                    Text(country.name)
                        .font(.caption.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
        .buttonStyle(.plain)
        .drawingGroup() // Flattens a subtree of views into a single bitmap.
    }

    private func imageContent(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(.ultraThinMaterial)
                    .blur(radius: 0.5)
            }
            .transition(.opacity.combined(with: .scale))
    }
}

struct FlagGridItem_Previews: PreviewProvider {
    static var previews: some View {
        FlagGridItem(country: .example, showsName: true)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
