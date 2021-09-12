//
//  CLLocationCoordinate2D+Decodable.swift
//  CLLocationCoordinate2D+Decodable
//
//  Created by Nayan Jansari on 05/09/2021.
//

import MapKit

extension CLLocationCoordinate2D: Decodable {
    private enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)

        self.init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D {
    func formatted() -> String {
        let formattedLatitude: String = {
            if latitude.isLess(than: .zero) {
                return "\(latitude.magnitude)º S"
            } else {
                return "\(latitude)º N"
            }
        }()

        let formattedLongitude: String = {
            if longitude.isLess(than: .zero) {
                return "\(longitude.magnitude)º W"
            } else {
                return "\(longitude)º E"
            }
        }()

        return "\(formattedLatitude), \(formattedLongitude)"
    }
}
