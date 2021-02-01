//
//  MapController.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import MapKit
import UIKit

class MapController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var navigationBarTitle: UINavigationItem!
    @IBOutlet private var mapView: MKMapView!


    // MARK: - Public

    var town: Town?


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Insert all annotations
        TownsData.all.forEach { town in
            mapView.addAnnotation(TownPin(with: town))
        }

        navigationBarTitle.title = town?.name
        mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2DMake(49.7437000, 15.3391333),
            span: MKCoordinateSpan(latitudeDelta: 2.5, longitudeDelta: 8.5)
        )
        mapView.slSensitive = true
        view.slSensitive = true
    }


    // MARK: - View setup

    func configureView() {
        navigationBarTitle.title = town?.name

        if let town = town {
            let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2.5)
            mapView.region = MKCoordinateRegion(center: town.coordinate, span: span)
        }
    }


    // MARK: - UI Actions

    @IBAction func doneButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}


extension MapController: MKMapViewDelegate {

    // MARK: - MKMapViewDelegate methods

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is TownPin {
            let townPin = annotation as? TownPin
            let marker = MKMarkerAnnotationView()

            if townPin?.town == town {
                marker.markerTintColor = UIColor.red
                marker.displayPriority = .required

            } else {
                marker.markerTintColor = UIColor.blue
                marker.displayPriority = .defaultHigh
            }

            return marker
        }

        return nil
    }
}
