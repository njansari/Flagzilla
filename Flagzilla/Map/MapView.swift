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
    let annotations: [MKAnnotation]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsBuildings = false

        mapView.register(FlagAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(FlagClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

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

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

extension MapView {
    @MainActor class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotationView = view as? FlagAnnotationView else { return }
            annotationView.flagDelegate.isSelected = true
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapType: .standard, annotations: [])
    }
}
