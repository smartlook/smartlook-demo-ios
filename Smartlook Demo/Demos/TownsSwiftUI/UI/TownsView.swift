//
//  TownsView.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 30.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import SwiftUI

struct TownsView: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationView {
            TownsListView()
                .navigationTitle("towns-demo-name")
                .navigationBarTitleDisplayMode(.inline)

            TownsDetailView(town: TownsData.all.first)
                .navigationTitle("Detail")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct TownsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TownsView()
                .previewLayout(.fixed(width: 1024, height: 786))
        }
    }
}
