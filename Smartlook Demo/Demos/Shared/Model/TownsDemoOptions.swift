//
//  TownsDemoOptions.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 18.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import Foundation

class TownsDemoOptions: ObservableObject {

    // MARK: - Public

    @Published var items: [DemoOption]


    // MARK: - Initialization

    init(items: [DemoOption] = [DemoOption]()) {
        self.items = items
    }


    // MARK: - Helpers

    func state(forId id: String) -> Bool? {
        return items.filter { $0.id == id }.first?.enabled
    }
}
