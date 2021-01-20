//
//  Selection.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 08.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

struct SelectionItem {

    // MARK: - Public

    let label: String
    let value: Any
    var selected: Bool = false
}

struct SelectionData {

    // MARK: - Public

    let id: String?
    var items = [SelectionItem]()


    // MARK: - Selection helpers

    func selected() -> [SelectionItem] {
        return items.filter {
            $0.selected == true
        }
    }

    func selectedValues() -> [Any] {
        selected().map {
            $0.value
        }
    }
}
