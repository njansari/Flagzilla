//
//  View+ForegroundStyleDisabled.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/12/2021.
//

import SwiftUI

extension View {
    @ViewBuilder func foregroundStyle<S: ShapeStyle>(_ style: S, disabled: Bool) -> some View {
        if disabled {
            foregroundStyle(.tertiary)
        } else {
            foregroundStyle(style)
        }
    }
}
