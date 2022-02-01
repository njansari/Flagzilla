//
//  FlagAnnotationView.swift
//  FlagAnnotationView
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit
import SwiftUI

// This is the annotation that shows the individual country's flag on a pole.
// The annotation view is made compatible with the map it is being assigned to.
final class FlagAnnotationView: MKAnnotationView {
    private let flagConfig = MapFlagConfiguration()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        let size = FlagView.flagOnPoleSize

        let flagView = FlagView(config: flagConfig)
            .offset(x: size.width / 2, y: size.height / 2)

        let flagViewController = UIHostingController(rootView: flagView)
        addSubview(flagViewController.view)

        frame.size = size

        // Adjust the position of the flag so that the bottom
        // of the pole is located at the country's coordinates.
        centerOffset = CGPoint(x: size.width / 2 - 5, y: -size.height / 2)

        calloutOffset.y = 10
        backgroundColor = .clear
        clusteringIdentifier = "flag"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        flagConfig.country = nil
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        guard let annotation = annotation as? FlagAnnotation else { return }
        flagConfig.country = annotation.country
    }
}
