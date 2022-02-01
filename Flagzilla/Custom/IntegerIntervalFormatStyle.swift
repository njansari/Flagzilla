//
//  IntegerIntervalFormatStyle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 01/02/2022.
//

import Foundation

extension Int {
    struct IntervalFormatStyle: FormatStyle {
        func format(_ value: ClosedRange<Int>) -> String {
            "\(value.lowerBound) - \(value.upperBound)"
        }
    }
}

extension FormatStyle where Self == Int.IntervalFormatStyle {
    static var integerInterval: Int.IntervalFormatStyle {
        Int.IntervalFormatStyle()
    }
}
