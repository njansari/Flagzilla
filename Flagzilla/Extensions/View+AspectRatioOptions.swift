//
//  View+AspectRatioOptions.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/12/2021.
//

import SwiftUI

extension View {
    func aspectRatio(options: FlagImageClassifier.ImageScaleOptions) -> some View {
        aspectRatio(options.aspectRatio, contentMode: options.contentMode)
    }
}
