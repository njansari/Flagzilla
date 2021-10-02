//
//  Image+Checkmarks.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 28/09/2021.
//

import SwiftUI

extension Image {
    static var unselectedCheckmark: some View {
        self.init(systemName: "circle")
            .foregroundStyle(.quaternary)
    }

    static var selectedCheckmark: some View {
        self.init(systemName: "checkmark.circle.fill")
            .foregroundStyle(.tint)
    }

    static var checkmark: some View {
        self.init(systemName: "checkmark")
            .font(.body.bold())
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
    }
}
