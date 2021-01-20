//
//  Town.swift
//  Smartlook Demo App
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit
import MapKit

struct Town: Equatable, Identifiable {

    // MARK: - Public

    var id = 0
    var name: String?
    var url: URL?
    var coordinate: CLLocationCoordinate2D

    var flag: UIImage? {
        if let flagAssetName = name {
            return UIImage(named: flagAssetName)
        }
        return nil
    }


    // MARK: - Initialization

    init(id: Int, name: String?, urlString: String?, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.coordinate = coordinate

        if let urlString = urlString {
            self.url = URL(string: urlString)
        }
    }
}

extension CLLocationCoordinate2D: Equatable {

    static public func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
