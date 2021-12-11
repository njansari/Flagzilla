//
//  Coordinate+Decodable.swift
//  Coordinate+Decodable
//
//  Created by Nayan Jansari on 05/09/2021.
//

import MapKit

typealias Coordinate = CLLocationCoordinate2D

extension Coordinate: Decodable {
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

    func formatted() -> String {
        let formatStyle = CoordinateFormatStyle()
        return formatStyle.format(self)
    }
}
