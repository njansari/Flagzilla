//  Image+Checkmarks.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 28/09/2021.
//

import SwiftUI

extension Image {
    static var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.body.bold())
            .foregroundStyle(.tint)
    }

    static var unselectedCheckmark: some View {
        Image(systemName: "circle")
            .foregroundStyle(.quaternary)
    }

    static var selectedCheckmark: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.tint)
    }
}

struct Image_Checkmarks_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image.checkmark
            Image.unselectedCheckmark
            Image.selectedCheckmark
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
