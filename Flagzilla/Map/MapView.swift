//
//  MapView.swift
//  MapView
//
//  Created by Nayan Jansari on 29/08/2021.
//

import MapKit
import SwiftUI

// The actual map that receives the annotations to show at the specified coordinates.
// This ports the map view from a different framework to a view used to show on screen.
struct MapView: UIViewRepresentable {
    let mapType: MKMapType
    let annotations: [FlagAnnotation]

    func makeUIView(context: Context) -> MKMapView {
        // Configures a map view removing all unnecessary visual details.
        let mapView = MKMapView()
        mapView.isRotateEnabled = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsBuildings = false

        // Registers the custom map annotation views with their respective annotation types.
        let annotationReuseID = MKMapViewDefaultAnnotationViewReuseIdentifier
        let clusterReuseID = MKMapViewDefaultClusterAnnotationViewReuseIdentifier

        mapView.register(FlagAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseID)
        mapView.register(FlagClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: clusterReuseID)

        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.mapType = mapType

        // If the number of annotations has changed, remove the old ones
        // and replace them with the new, updated ones.
        if uiView.annotations.count != annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
            uiView.showAnnotations(annotations, animated: true)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapType: .standard, annotations: countries.map(FlagAnnotation.init))
            .ignoresSafeArea()
    }
}
