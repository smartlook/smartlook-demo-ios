//
//  DemosData.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 15.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

struct DemoOption {

    // MARK: - Public

    let id: String
    var enabled: Bool = true


    // MARK: - Localized texts

    var nameLocalized: String {
        "\(id)-option-name".localized
    }
}

struct DemoDetail {

    // MARK: - Public

    let showNotes: Bool
    let showDeveloperNotes: Bool

    var options: [DemoOption]?


    // MARK: - Initialization

    init(showNotes: Bool = true, showDeveloperNotes: Bool = true, options: [DemoOption]? = nil) {
        self.showNotes = showNotes
        self.showDeveloperNotes = showDeveloperNotes
        self.options = options
    }
}

struct DemoItem {

    // MARK: - Public

    let id: String
    let technology: String

    let icon: UIImage
    let iconColor: UIColor

    let storyboardName: String
    let storyboardId: String?

    var detail: DemoDetail?


    // MARK: - Localized texts

    var nameLocalized: String {
        "\(id)-name".localized
    }
    var perexLocalized: String {
        "\(id)-perex".localized
    }

    var notesLocalized: String? {
        if detail?.showNotes == true {
            return "\(id)-notes".localized
        }
        return nil
    }

    var developerNotesLocalized: String? {
        if detail?.showDeveloperNotes == true {
            return "\(id)-developer-notes".localized
        }
        return nil
    }


    // MARK: - Initialization

    init(id: String, technology: String, icon: UIImage?, iconColor: UIColor,
         storyboardName: String, storyboardId: String? = nil, detail: DemoDetail? = nil) {
        self.id = id
        self.technology = technology
        self.icon = icon ?? UIImage()
        self.iconColor = iconColor
        self.storyboardName = storyboardName
        self.storyboardId = storyboardId
        self.detail = detail
    }
}


struct DemosData {

    // MARK: - Public

    static let all: [DemoItem] = [
        DemoItem(id: "towns-demo", technology: "UIKit",
                 icon: UIImage(systemName: "switch.2"), iconColor: .systemOrange, storyboardName: "Towns",
                 detail: DemoDetail(options: [
                    DemoOption(id: "map-sensitivity"),
                    DemoOption(id: "track-town-selection")
                 ])
        ),

        DemoItem(id: "towns-swiftui-demo", technology: "SwiftUI",
                 icon: UIImage(systemName: "swift"), iconColor: .systemBlue, storyboardName: "TownsSwiftUI",
                 detail: DemoDetail(options: [
                    DemoOption(id: "map-sensitivity")
                 ])
        )
    ]
}
