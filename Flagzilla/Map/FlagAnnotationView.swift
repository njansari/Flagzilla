//
//  FlagAnnotationView.swift
//  FlagAnnotationView
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit
import SwiftUI

final class FlagAnnotationView: MKAnnotationView {
    private let flagDelegate = FlagDelegate()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        let size = FlagView.flagOnPoleSize

        let flagView = FlagView(delegate: flagDelegate)
            .offset(x: size.width / 2, y: size.height / 2)

        let flagViewController = UIHostingController(rootView: flagView)
        addSubview(flagViewController.view)

        frame.size = size
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

        flagDelegate.country = nil
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        guard let annotation = annotation as? FlagAnnotation else { return }
        flagDelegate.country = annotation.country
    }
}
