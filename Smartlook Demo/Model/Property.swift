//
//  Property.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 17.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

struct PropertyItem: Codable, Equatable {

    // MARK: - Public

    var name: String
    var value: String


    // MARK: - Initialization

    init(name: String = "", value: String = "") {
        self.name = name
        self.value = value
    }

    func isValid() -> Bool {
        return !name.isEmpty && !value.isEmpty
    }
}

struct PropertiesData: Codable {

    // MARK: - Public

    let id: String?
    var items = [PropertyItem]()


    // MARK: - PropertiesData update helpers

    static func updateProperties(from oldValue: PropertiesData, to newValue: PropertiesData,
                                 delete: ((PropertyItem) -> Void), update: ((PropertyItem) -> Void)) {
        // Remove deleted
        oldValue.items.forEach { (property) in
            let deleted = newValue.items.filter {
                $0.name == property.name
            }.isEmpty

            if deleted {
                delete(property)
            }
        }

        // Update/set others
        newValue.items.forEach { (property) in
            update(property)
        }
    }
}
