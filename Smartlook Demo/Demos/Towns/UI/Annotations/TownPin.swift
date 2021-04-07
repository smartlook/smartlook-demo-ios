//
//  TownPin.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import MapKit

class TownPin: NSObject, MKAnnotation {

    // MARK: - Public

    private(set) var town: Town


    // MARK: - Initialization

    init(with town: Town) {
        self.town = town
    }


    // MARK: - MKAnnotation methods

    var coordinate: CLLocationCoordinate2D {
        town.coordinate
    }

    var title: String? {
        town.name
    }
}
