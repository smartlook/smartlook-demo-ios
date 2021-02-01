//
//  AppSettings.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 12.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import Smartlook

internal struct AppSettingsSelectionItem<T: Codable>: Codable {

    // MARK: - Public

    let label: String
    let value: T
    var selected: Bool = false
}

internal struct AppSettingsSelectionData<T: Codable>: Codable {

    // MARK: - Public

    let id: String?
    var items = [AppSettingsSelectionItem<T>]()
}

struct AppSettings: Codable {

    // MARK: - Public

    let smartlookApiKey: String?

    let renderingMode: Smartlook.RenderingMode
    let renderingModeOption: Smartlook.RenderingModeOption?
    let framerate: Int
    let useAdaptiveFramerate: Bool

    let denyList: AppSettingsSelectionData<String>
    let userIdentifier: String?
    let sessionProperties: PropertiesData

    let eventTrackingModeItems: AppSettingsSelectionData<Smartlook.EventTrackingMode>
    let globalProperties: PropertiesData
}


extension Smartlook.RenderingMode: Codable {}

extension Smartlook.RenderingModeOption: Codable {}

extension Smartlook.EventTrackingMode: Codable {}
