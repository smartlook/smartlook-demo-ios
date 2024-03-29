//
//  Town.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import MapKit
import UIKit

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
            url = URL(string: urlString)
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
