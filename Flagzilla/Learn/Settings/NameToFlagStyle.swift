//
//  NameToFlagStyle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 19/09/2021.
//

import SwiftUI

struct NameToFlagStyle: View {
    private var textQuestion: some View {
        RoundedRectangle(cornerRadius: 2, style: .continuous)
            .fill(.tint)
            .overlay {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.white)
            }
            .frame(height: 15)
    }

    private var flagOption: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(.tertiary)
            .overlay {
                Image(systemName: "flag")
                    .symbolVariant(.fill)
            }
    }

    var body: some View {
        VStack {
            textQuestion

            Spacer()

            ForEach(0..<2) { _ in
                HStack {
                    flagOption
                    flagOption
                }
                .frame(height: 30)
            }
        }
        .font(.system(size: 15))
        .foregroundStyle(.white, .tertiary)
        .frame(height: 100)
        .accessibilityAddTraits(.isButton)
    }
}

struct NameToFlagStyle_Previews: PreviewProvider {
    static var previews: some View {
        NameToFlagStyle()
            .frame(width: 100)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
