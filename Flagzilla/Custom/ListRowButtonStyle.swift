//
//  ListRowButtonStyle.swift
//  ListRowButtonStyle
//
//  Created by Nayan Jansari on 07/09/2021.
//

import SwiftUI

struct ListRowButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: configuration.trigger) {
            configuration.label
                .font(.headline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .listRowInsets(EdgeInsets())
    }
}

extension PrimitiveButtonStyle where Self == ListRowButtonStyle {
    static var listRow: ListRowButtonStyle {
        ListRowButtonStyle()
    }
}
