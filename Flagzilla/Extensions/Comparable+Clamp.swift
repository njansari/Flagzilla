//
//  Comparable+Clamp.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/10/2021.
//

import Foundation

extension Comparable {
    mutating func clamp(to limits: ClosedRange<Self>) {
        self = min(max(self, limits.lowerBound), limits.upperBound)
    }
}
