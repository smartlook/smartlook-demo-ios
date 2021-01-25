//
//  TownsData.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import MapKit

struct TownsData {

    // MARK: - Public

    static let all: [Town] = [
        Town(id: 0, name: "Praha", urlString: "https://wikipedia.org/wiki/Praha",
             coordinate: CLLocationCoordinate2DMake(50.083333, 14.416667)),

        Town(id: 1, name: "Brno", urlString: "https://wikipedia.org/wiki/Brno",
             coordinate: CLLocationCoordinate2DMake(49.195278, 16.60833)),

        Town(id: 2, name: "Ostrava", urlString: "https://wikipedia.org/wiki/Ostrava",
             coordinate: CLLocationCoordinate2DMake(49.835556, 18.2925)),

        Town(id: 3, name: "Plzeň", urlString: "https://wikipedia.org/wiki/Plze%C5%88",
             coordinate: CLLocationCoordinate2DMake(49.741389, 13.3825)),

        Town(id: 4, name: "Liberec", urlString: "https://wikipedia.org/wiki/Liberec",
             coordinate: CLLocationCoordinate2DMake(50.769997, 15.058449)),

        Town(id: 5, name: "Olomouc", urlString: "https://wikipedia.org/wiki/Olomouc",
             coordinate: CLLocationCoordinate2DMake(49.593889, 17.250833)),

        Town(id: 6, name: "České Budějovice", urlString: "https://wikipedia.org/wiki/%C4%8Cesk%C3%A9_Bud%C4%9Bjovice",
             coordinate: CLLocationCoordinate2DMake(48.974722, 14.474722)),

        Town(id: 7, name: "Hradec Králové", urlString: "https://wikipedia.org/wiki/Hradec_Kr%C3%A1lov%C3%A9",
             coordinate: CLLocationCoordinate2DMake(50.209167, 15.831944)),

        Town(id: 8, name: "Ústí nad Labem", urlString: "https://wikipedia.org/wiki/%C3%9Ast%C3%AD_nad_Labem",
             coordinate: CLLocationCoordinate2DMake(50.659167, 14.041667)),

        Town(id: 9, name: "Pardubice", urlString: "https://wikipedia.org/wiki/Pardubice",
             coordinate: CLLocationCoordinate2DMake(50.03861, 15.77916)),

        Town(id: 10, name: "Zlín", urlString: "https://wikipedia.org/wiki/Zl%C3%ADn",
             coordinate: CLLocationCoordinate2DMake(49.233056, 17.666944)),

        Town(id: 11, name: "Havířov", urlString: "https://wikipedia.org/wiki/Hav%C3%AD%C5%99ov",
             coordinate: CLLocationCoordinate2DMake(49.777778, 18.422778)),

        Town(id: 12, name: "Kladno", urlString: "https://wikipedia.org/wiki/Kladno",
             coordinate: CLLocationCoordinate2DMake(50.143056, 14.105278)),

        Town(id: 13, name: "Most", urlString: "https://cs.wikipedia.org/wiki/Most_%28m%C4%9Bsto%29",
             coordinate: CLLocationCoordinate2DMake(50.503056, 13.636667)),

        Town(id: 14, name: "Opava", urlString: "https://wikipedia.org/wiki/Opava",
             coordinate: CLLocationCoordinate2DMake(49.938056, 17.904444)),

        Town(id: 15, name: "Frýdek Místek", urlString: "https://wikipedia.org/wiki/Fr%C3%BDdek-M%C3%ADstek",
             coordinate: CLLocationCoordinate2DMake(49.688056, 18.353611)),

        Town(id: 16, name: "Karviná", urlString: "https://wikipedia.org/wiki/Karvin%C3%A1",
             coordinate: CLLocationCoordinate2DMake(49.854167, 18.542778)),

        Town(id: 17, name: "Jihlava", urlString: "https://wikipedia.org/wiki/Jihlava",
             coordinate: CLLocationCoordinate2DMake(49.400278, 15.590556)),

        Town(id: 18, name: "Teplice", urlString: "https://wikipedia.org/wiki/Teplice",
             coordinate: CLLocationCoordinate2DMake(50.633333, 13.816667)),

        Town(id: 19, name: "Děčín", urlString: "https://wikipedia.org/wiki/D%C4%9B%C4%8D%C3%ADn",
             coordinate: CLLocationCoordinate2DMake(50.773611, 14.196111)),

        Town(id: 20, name: "Karlovy Vary", urlString: "https://wikipedia.org/wiki/Karlovy_Vary",
             coordinate: CLLocationCoordinate2DMake(50.230556, 12.8725)),

        Town(id: 21, name: "Jablonec nad Nisou", urlString: "https://wikipedia.org/wiki/Jablonec_nad_Nisou",
             coordinate: CLLocationCoordinate2DMake(50.727778, 15.17)),

        Town(id: 22, name: "Mladá Boleslav", urlString: "https://wikipedia.org/wiki/Mlad%C3%A1_Boleslav",
             coordinate: CLLocationCoordinate2DMake(50.4125, 14.906389)),

        Town(id: 23, name: "Prostějov", urlString: "https://wikipedia.org/wiki/Prost%C4%9Bjov",
             coordinate: CLLocationCoordinate2DMake(49.472222, 17.110556)),

        Town(id: 24, name: "Přerov", urlString: "https://wikipedia.org/wiki/P%C5%99erov",
             coordinate: CLLocationCoordinate2DMake(49.455556, 17.451111)),

        Town(id: 25, name: "Česká Lípa", urlString: "https://wikipedia.org/wiki/%C4%8Cesk%C3%A1_L%C3%ADpa",
             coordinate: CLLocationCoordinate2DMake(50.685584, 14.537747))
    ]


    // MARK: - Filtering

    static func filtered(by serachText: String?) -> [Town] {
        if let term = serachText, !term.isEmpty {
            let filteredData = all.filter {
                ($0.name?.lowercased() ?? "").contains(term.lowercased())
            }
            return filteredData
        }

        return all
    }
}
