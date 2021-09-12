//
//  FlagGridItem.swift
//  FlagGridItem
//
//  Created by Nayan Jansari on 12/09/2021.
//

import SwiftUI

struct FlagGridItem: View {
    let country: Country

    let transaction = Transaction(animation: .spring())

    var placeholderColor: Color {
        let colors: [Color] = [.blue, .cyan, .green, .indigo, .mint, .orange, .primary, .red, .yellow]

        return colors.randomElement()!.opacity(0.6)
    }

    var body: some View {
        NavigationLink {
            CountryView(country: country)
        } label: {
            AsyncImage(url: country.gridFlag, scale: 3, transaction: transaction, content: imageContent)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                .frame(width: 110, height: 80)
        }
    }

    @ViewBuilder func imageContent(phase: AsyncImagePhase) -> some View {
        switch phase {
            case .failure(let error):
                VStack {
                    Image(systemName: "xmark.octagon")
                        .font(.largeTitle)
                        .symbolVariant(.fill)

                    Text(error.localizedDescription)
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(.red)

            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .strokeBorder(.thickMaterial, lineWidth: 1)
                    }
                    .transition(.opacity.combined(with: .scale))

            default:
                placeholderColor
                    .overlay(content: ProgressView.init)
                    .tint(.primary)
                    .transition(.opacity.combined(with: .scale))
        }
    }
}

struct FlagGridItem_Previews: PreviewProvider {
    static var previews: some View {
        FlagGridItem(country: .example)
    }
}