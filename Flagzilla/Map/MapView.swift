//
//  MapView.swift
//  MapView
//
//  Created by Nayan Jansari on 29/08/2021.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    let mapType: MKMapType
    let annotations: [FlagAnnotation]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isRotateEnabled = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsBuildings = false

        let annotationReuseID = MKMapViewDefaultAnnotationViewReuseIdentifier
        let clusterReuseID = MKMapViewDefaultClusterAnnotationViewReuseIdentifier

        mapView.register(FlagAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseID)
        mapView.register(FlagClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: clusterReuseID)

        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.mapType = mapType

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
    }
}
