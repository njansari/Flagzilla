//
//  FlagAnnotationView.swift
//  FlagAnnotationView
//
//  Created by Nayan Jansari on 12/09/2021.
//

import MapKit
import SwiftUI

@MainActor class FlagAnnotationView: MKAnnotationView {
    private let flagDelegate: FlagDelegate

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        flagDelegate = FlagDelegate()

        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        let flagView = FlagView(delegate: flagDelegate).onSizeChange { size in
            self.centerOffset = CGPoint(x: size.width / 2 - 5, y: -size.height / 2)
            self.calloutOffset.y = -size.height / 3
        }

        let flagViewController = UIHostingController(rootView: flagView)

        addSubview(flagViewController.view)

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
