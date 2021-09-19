//
//  FlagToTextStyle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 19/09/2021.
//

import SwiftUI

struct FlagToTextStyle: View {
    var flagQuestion: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(.tint)
            .overlay {
                Image(systemName: "flag")
                    .symbolVariant(.fill)
                    .font(.system(size: 30))
            }
            .frame(height: 60)
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

            ForEach(0..<2) { _ in
                HStack {
                    textOption
                    textOption
                }
                .frame(height: 10)
            }
        }
        .font(.system(size: 15))
        .foregroundStyle(.white, .tertiary)
        .frame(height: 100)
    }
}

struct FlagToTextStyle_Previews: PreviewProvider {
    static var previews: some View {
        FlagToTextStyle()
            .frame(width: 100)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
