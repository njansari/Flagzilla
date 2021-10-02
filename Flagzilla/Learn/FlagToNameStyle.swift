//
//  FlagToNameStyle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 19/09/2021.
//

import SwiftUI

struct FlagToNameStyle: View {
    var flagQuestion: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(.tint)
            .overlay {
                Image(systemName: "flag")
                    .symbolVariant(.fill)
                    .font(.system(size: 25))
            }
            .frame(height: 50)
    }

    var textOption: some View {
        RoundedRectangle(cornerRadius: 2, style: .continuous)
            .fill(.tertiary)
            .overlay {
                Image(systemName: "ellipsis")
            }
    }

    var body: some View {
        VStack {
            flagQuestion

            Spacer()

            VStack(spacing: 5) {
                ForEach(0..<3) { _ in
                    textOption
                        .frame(height: 10)
                }
            }
        }
        .font(.system(size: 15))
        .foregroundStyle(.white, .tertiary)
        .frame(height: 100)
    }
}

struct FlagToNameStyle_Previews: PreviewProvider {
    static var previews: some View {
        FlagToNameStyle()
            .frame(width: 100)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
