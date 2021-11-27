//
//  RoundedCornerRectangle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 26/11/2021.
//

import SwiftUI

struct RoundedCornerRectangle: Shape {
    let corners: UIRectCorner
    let radius: Double

    init(_ corners: UIRectCorner, cornerRadius: Double) {
        self.corners = corners
        self.radius = cornerRadius
    }

    func path(in rect: CGRect) -> Path {
        let radii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)

        return Path(path.cgPath)
    }
}
