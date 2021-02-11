//
//  AppSettingsManager.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 12.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import Foundation
import Smartlook
import SmartlookConsentSDK

class AppSettingsManager {

    // MARK: - Settings synchronization

    func sync() {
        // Loads last settings state from storage and apply to SDK
        if let appSettings = load() {
            updateSettingsData(with: appSettings)
            SettingsData.updateConfiguration()

            return
        }

        // If we do not have yet any setting saved,
        // we will try get some from the Smartlook SDK
        if Smartlook.isRecording() {
            save()
        } else {
            if SettingsData.isApiKeyValid {
                Smartlook.startRecording()
            }

            save()
            Smartlook.stopRecording()
        }
    }

    func sync(withNewApiKey apiKey: String?) {
        // Update stored Api key
        SettingsData.smartlookApiKey = apiKey
        SettingsData.updateConfiguration()

        // Store last settings
        AppSettingsManager().save()

        let isApiKeyValid = SettingsData.isApiKeyValid
        if Smartlook.isRecording() {
            // If key is invalid now, we will stop recording
            if !isApiKeyValid {
                Smartlook.stopRecording()
            }
        } else {
            // If key is valid and we have consent, we run recording
            if isApiKeyValid, SmartlookConsentSDK.consentState(for: .privacy) == .provided {
                Smartlook.startRecording()
            }
        }

        // Notify about this configuration change
        let notificationName = SettingsData.smartlookSettingsUpdatedNotification
        NotificationCenter.default.post(name: notificationName, object: nil)
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

            denyList: appSettingsSelectionData(from: SettingsData.Privacy.denyList),
            userIdentifier: SettingsData.Privacy.userIdentifier,
            sessionProperties: SettingsData.Privacy.sessionProperties,

            eventTrackingModeItems: appSettingsSelectionData(from: SettingsData.Analytics.eventTrackingModeItems),
            globalProperties: SettingsData.Analytics.globalProperties
        )
    }

    private func updateSettingsData(with appSettings: AppSettings) {
        if let smartlookApiKey = appSettings.smartlookApiKey, !smartlookApiKey.isEmpty {
            SettingsData.smartlookApiKey = appSettings.smartlookApiKey
        }

        SettingsData.Rendering.currentMode = appSettings.renderingMode
        SettingsData.Rendering.currentModeOption = appSettings.renderingModeOption

        SettingsData.Privacy.denyList = selectionData(from: appSettings.denyList)
        SettingsData.Privacy.userIdentifier = appSettings.userIdentifier
        SettingsData.Privacy.sessionProperties = appSettings.sessionProperties

        SettingsData.Analytics.eventTrackingModeItems = selectionData(from: appSettings.eventTrackingModeItems)
        SettingsData.Analytics.globalProperties = appSettings.globalProperties
    }


    // MARK: - Selection models transformation

    private func appSettingsSelectionData<T: Codable>(from selectionData: SelectionData) -> AppSettingsSelectionData<T> {
        var appSettingsSelectionData = AppSettingsSelectionData<T>(id: selectionData.id, items: [AppSettingsSelectionItem<T>]())
        selectionData.items.forEach { item in
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
        appSettingsSelectionData.items.forEach { item in
            selectionData.items.append(
                SelectionItem(label: item.label, value: item.value, selected: item.selected)
            )
        }

        return selectionData
    }
}


extension UserDefaults {

    enum Key {
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
