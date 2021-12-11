//
//  FlagClusterAnnotationView.swift
//  FlagClusterAnnotationView
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit
import SwiftUI

final class FlagClusterAnnotationView: MKAnnotationView {
    private let flagDelegate = FlagDelegate()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        let size = FlagView.flagSize

        let flagView = FlagView(delegate: flagDelegate)
            .offset(x: size.width / 2, y: size.height / 2)

        let flagViewController = UIHostingController(rootView: flagView)
        addSubview(flagViewController.view)

        frame.size = size
        centerOffset = CGPoint(x: size.width / 2, y: -size.height / 2)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        flagDelegate.country = nil
        flagDelegate.clusterCount = 0
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        guard let clusterAnnotation = annotation as? MKClusterAnnotation,
              let annotations = clusterAnnotation.memberAnnotations as? [FlagAnnotation],
              !annotations.isEmpty
        else { return }

        flagDelegate.country = annotations[0].country
        flagDelegate.clusterCount = annotations.count
    }
}
