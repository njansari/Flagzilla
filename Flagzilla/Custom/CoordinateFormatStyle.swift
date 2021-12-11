//
//  CoordinateFormatStyle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 04/12/2021.
//

import Foundation

struct CoordinateFormatStyle: FormatStyle {
    func format(_ value: Coordinate) -> String {
        let formattedLatitude: String = {
            if value.latitude.isLess(than: .zero) {
                return "\(value.latitude.magnitude)º S"
            } else {
                return "\(value.latitude)º N"
            }
        }()

        let formattedLongitude: String = {
            if value.longitude.isLess(than: .zero) {
                return "\(value.longitude.magnitude)º W"
            } else {
                return "\(value.longitude)º E"
            }
        }()

        return "\(formattedLatitude), \(formattedLongitude)"
    }
}
