//
//  TownsMapView.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 04.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import SwiftUI
import MapKit

struct TownsMapView: View {
    var town: Town?
    @Binding var showing: Bool

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2DMake(49.7437000, 15.3391333),
        span: MKCoordinateSpan(latitudeDelta: 2.5, longitudeDelta: 8.5)
    )

    // Current run options
    @EnvironmentObject var demoOptions: TownsDemoOptions
    private var isMapSensitive: Bool {
        demoOptions.state(forId: "map-sensitivity") ?? false
    }

    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: TownsData.all) { place in
                MapMarker(coordinate: place.coordinate, tint: place == town ? .red : .blue)
            }
            .smartlookSensitive(enabled: isMapSensitive)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(town?.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                showing = false
            })
        }
    }
}

struct TownsMapView_Previews: PreviewProvider {
    static var previews: some View {
        TownsMapView(showing: .constant(false))
    }
}
