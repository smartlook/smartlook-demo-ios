//
//  TownsListView.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 30.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import SwiftUI

struct TownsListView: View {
    @State private var searchText: String = ""

    private var filteredModel: [Town] {
        TownsData.filtered(by: searchText)
    }

    // Current run options
    @EnvironmentObject var demoOptions: TownsDemoOptions
    private var trackSelection: Bool {
        demoOptions.state(forId: "track-town-selection") ?? true
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(text: $searchText)

            List(filteredModel, id: \.id) { town in
                NavigationLink(
                    destination: TownsDetailView(town: town),
                    label: {
                        TownsListRowView(town: town)
                            .padding(0)
                    }
                )
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("towns-demo-name")
        .navigationBarItems(trailing: Button("Close") {
            closeButtonPressed()
        })
    }


    // MARK: - UI Actions

    private func closeButtonPressed() {
        let rootViewController = UIApplication.shared.windows.filter {
            $0.isKeyWindow
        }.first?.rootViewController as? UINavigationController

        rootViewController?.dismiss(animated: true)
    }
}

struct TownsListView_Previews: PreviewProvider {
    static var previews: some View {
        TownsListView()
    }
}
