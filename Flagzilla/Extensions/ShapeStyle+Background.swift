//
//  ShapeStyle+Background.swift
//  ShapeStyle+Background
//
//  Created by Nayan Jansari on 12/09/2021.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var backgroundColor: Color {
        Color(uiColor: .systemBackground)
    }

    static var groupedBackground: Color {
        Color(uiColor: .systemGroupedBackground)
    }

    static var tertiaryGroupedBackground: Color {
        Color(uiColor: .tertiarySystemGroupedBackground)
    }
}
