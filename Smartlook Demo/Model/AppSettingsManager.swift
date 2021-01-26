//
//  AppSettingsManager.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 12.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import Foundation
import Smartlook

class AppSettingsManager {

    // MARK: - Settings synchronization

    func sync() {
        // Loads last settings state from storage and apply to SDK
        if let appSettings = load() {
            updateSettingsData(with: appSettings)

            return
        }

        // If we do not have yet any setting saved,
        // we will try get some from the Smartlook SDK
        if Smartlook.isRecording() {
            save()
        } else {
            Smartlook.startRecording()
            save()
            Smartlook.stopRecording()
        }
    }


    // MARK: - Persistence of settings data

    func save() {
        let appSettings = currentAppSettings()

        // Save settings to storage
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(appSettings) {
            UserDefaults.standard.applicationSettingsStorage = encoded
        }
    }

    func load() -> AppSettings? {
        if let savedAppSettings = UserDefaults.standard.applicationSettingsStorage {
            let decoder = JSONDecoder()
            if let loadedAppSettings = try? decoder.decode(AppSettings.self, from: savedAppSettings) {
                return loadedAppSettings
            }
        }

        return nil
    }


    // MARK: - Settings model transformation

    private func currentAppSettings() -> AppSettings {
        return AppSettings(
            smartlookApiKey: SettingsData.smartlookApiKey,

            renderingMode: SettingsData.Rendering.currentMode,
            renderingModeOption: SettingsData.Rendering.currentModeOption,
            framerate: SettingsData.Rendering.framerate,
            useAdaptiveFramerate: SettingsData.Rendering.useAdaptiveFramerate,

            denyList: appSettingsSelectionData(from: SettingsData.Privacy.denyList),
            userIdentifier: SettingsData.Privacy.userIdentifier,
            sessionProperties: SettingsData.Privacy.sessionProperties,

            eventTrackingModeItems: appSettingsSelectionData(from: SettingsData.Analytics.eventTrackingModeItems),
            globalProperties: SettingsData.Analytics.globalProperties
        )
    }

    private func updateSettingsData(with appSettings: AppSettings) {
        if SettingsData.smartlookApiKey.isEmpty {
            SettingsData.smartlookApiKey = appSettings.smartlookApiKey ?? ""
        }

        SettingsData.Rendering.currentMode = appSettings.renderingMode
        SettingsData.Rendering.currentModeOption = appSettings.renderingModeOption
        SettingsData.Rendering.framerate = appSettings.framerate
        SettingsData.Rendering.useAdaptiveFramerate = appSettings.useAdaptiveFramerate

        SettingsData.Privacy.denyList = selectionData(from: appSettings.denyList)
        SettingsData.Privacy.userIdentifier = appSettings.userIdentifier
        SettingsData.Privacy.sessionProperties = appSettings.sessionProperties

        SettingsData.Analytics.eventTrackingModeItems = selectionData(from: appSettings.eventTrackingModeItems)
        SettingsData.Analytics.globalProperties = appSettings.globalProperties
    }


    // MARK: - Selection models transformation

    private func appSettingsSelectionData<T: Codable>(from selectionData: SelectionData) -> AppSettingsSelectionData<T> {
        var appSettingsSelectionData = AppSettingsSelectionData<T>(id: selectionData.id, items: [AppSettingsSelectionItem<T>]())
        selectionData.items.forEach { (item) in
            if let value = item.value as? T {
                appSettingsSelectionData.items.append(
                    AppSettingsSelectionItem(label: item.label, value: value, selected: item.selected)
                )
            }
        }

        return appSettingsSelectionData
    }

    private func selectionData<T: Any>(from appSettingsSelectionData: AppSettingsSelectionData<T>) -> SelectionData {
        var selectionData = SelectionData(id: appSettingsSelectionData.id, items: [SelectionItem]())
        appSettingsSelectionData.items.forEach { (item) in
            selectionData.items.append(
                SelectionItem(label: item.label, value: item.value, selected: item.selected)
            )
        }

        return selectionData
    }
}


extension UserDefaults {

    struct Key {
        static let applicationSettingsStorage = "applicationSettingsStorage"
    }

    @objc dynamic var applicationSettingsStorage: Data? {
        get {
            return value(forKey: Key.applicationSettingsStorage) as? Data
        }
        set {
            set(newValue, forKey: Key.applicationSettingsStorage)
        }
    }
}
