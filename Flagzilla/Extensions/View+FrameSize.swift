//
//  View+FrameSize.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 17/12/2021.
//

import SwiftUI

extension View {
    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        frame(width: size.width, height: size.height)
    }

    func infiniteMaxFrame() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func infiniteMaxWidth() -> some View {
        frame(maxWidth: .infinity)
    }

    func infiniteMaxHeight() -> some View {
        frame(maxHeight: .infinity)
    }
}
