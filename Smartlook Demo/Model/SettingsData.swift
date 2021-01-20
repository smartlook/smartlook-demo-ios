//
//  SettingsData.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 08.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import Smartlook
import WebKit

/// Data store
struct SettingsData {

    /// Smartlook Api Key
    static var smartlookApiKey = ""

    /// Settings for rendering framerate. It is not preserved between application starts.
    /// The next time you run it, it will be overwritten by the settings from the Smartlook portal.
    struct Rendering {

        // MARK: - Public

        /// Current method for capturing screen image data.
        static var currentMode: Smartlook.RenderingMode {
            get {
                Smartlook.currentRenderingMode()
            }
            set {
                Smartlook.setRenderingMode(to: newValue)
            }
        }

        /// Currently active rendering mode option.
        static var currentModeOption: Smartlook.RenderingModeOption? {
            get {
                Smartlook.currentRenderingModeOption()
            }
            set {
                let renderingMode = Smartlook.currentRenderingMode()
                Smartlook.setRenderingMode(to: renderingMode, option: newValue)
            }
        }

        /// Recorded video frame rate (allowed values between 2 and 10).
        static var framerate: Int = 2 {
            didSet {
                SettingsData.updateConfiguration()
            }
        }
        /// Determines if Smartlook adapts its recording framerate to the frequency of UI changes.
        static var useAdaptiveFramerate: Bool = true {
            didSet {
                SettingsData.updateConfiguration()
            }
        }

        static var modeItems: SelectionData {
            let availableModes = [
                Smartlook.RenderingMode.native,
                Smartlook.RenderingMode.wireframe,
                Smartlook.RenderingMode.noRendering
            ]

            var items = [SelectionItem]()
            for mode in availableModes {
                let isCurrent = mode == Smartlook.currentRenderingMode()
                items.append(SelectionItem(label: mode.rawValue, value: mode, selected: isCurrent))
            }

            return SelectionData(id: "renderingModes", items: items)
        }

        static var modeOptionItems: SelectionData {
            let availableModeOptions = [
                Smartlook.RenderingModeOption.none,
                Smartlook.RenderingModeOption.colorWireframe,
                Smartlook.RenderingModeOption.blueprintWireframe,
                Smartlook.RenderingModeOption.iconBlueprintWireframe
            ]

            var items = [SelectionItem]()
            for modeOption in availableModeOptions {
                let isCurrent = modeOption == Smartlook.currentRenderingModeOption() ?? .none
                items.append(SelectionItem(label: modeOption.rawValue, value: modeOption, selected: isCurrent))
            }

            return SelectionData(id: "renderingOptions", items: items)
        }
    }

    struct Privacy {

        // MARK: - Public

        static var denyList = defaultDenyList() {
            didSet {
                // Update classes on deny list
                for (index, item) in denyList.items.enumerated() {
                    guard index < defaultDenyClases.count else {
                        continue
                    }

                    let itemClass: AnyClass = defaultDenyClases[index]
                    if item.selected {
                        Smartlook.registerBlacklisted(object: itemClass.self)
                    } else {
                        Smartlook.unregisterBlacklisted(object: itemClass.self)
                    }
                }
            }
        }

        static var userIdentifier: String? {
            didSet {
                if userIdentifier?.isEmpty ?? false {
                    userIdentifier = nil
                }

                // Updates user identification
                Smartlook.setUserIdentifier(userIdentifier)
            }
        }

        static var sessionProperties = PropertiesData(id: "sessionProperties") {
            didSet {
                PropertiesData.updateProperties(from: oldValue, to: sessionProperties,
                    delete: { (property) in
                        Smartlook.removeSessionProperty(forName: property.name)
                    }, update: { (property) in
                        Smartlook.setSessionProperty(value: property.name, forName: property.value)
                    }
                )
            }
        }


        // MARK: - Private

        private static var defaultDenyClases: [AnyClass] {
            [
                UITextView.self,
                UITextField.self,
                WKWebView.self
            ]
        }

        // MARK: - Private methods

        private static func defaultDenyList() -> SelectionData {
            var items = [SelectionItem]()
            for denyClass in defaultDenyClases {
                let denyClassName = String(describing: denyClass)
                let selected = denyClassName != "WKWebView" ? true : false
                items.append(SelectionItem(label: denyClassName, value: denyClassName, selected: selected))
            }

            return SelectionData(id: "privacyDenyList", items: items)
        }
    }

    struct Analytics {

        // MARK: - Public

        static var eventTrackingModeItems = defaultEventTrackingModes() {
            didSet {
                // Update tracking modes
                if let eventTrackingModes = eventTrackingModeItems.selectedValues() as? [Smartlook.EventTrackingMode] {
                    Smartlook.setEventTrackingModes(to: eventTrackingModes)
                }
            }
        }

        static var globalProperties = PropertiesData(id: "globalProperties") {
            didSet {
                PropertiesData.updateProperties(from: oldValue, to: globalProperties,
                    delete: { (property) in
                        Smartlook.removeGlobalEventProperty(forName: property.name)
                    }, update: { (property) in
                        Smartlook.setGlobalEventProperty(value: property.name, forName: property.value)
                    }
                )
            }
        }


        // MARK: - Private methods

        private static func defaultEventTrackingModes() -> SelectionData {
            let availableTrackingOptions = [
                Smartlook.EventTrackingMode.ignoreUserInteractionEvents,
                Smartlook.EventTrackingMode.ignoreNavigationInteractionEvents,
                Smartlook.EventTrackingMode.ignoreRageClickEvents,
                Smartlook.EventTrackingMode.noTracking
            ]

            let currentTrackingOptions = Smartlook.currentEventTrackingModes()
            var items = [SelectionItem]()

            for trackingOption in availableTrackingOptions {
                let isCurrent = currentTrackingOptions.contains(trackingOption)
                items.append(SelectionItem(label: trackingOption.rawValue, value: trackingOption, selected: isCurrent))
            }

            return SelectionData(id: "eventTrackingModes", items: items)
        }
    }


    // MARK: - Smartlook session

    /// Builds Smartlook configuration with actual parameters.
    static func smartlookConfig() -> Smartlook.SetupConfiguration {
        let renderingMode = Smartlook.currentRenderingMode()
        let renderingModeOption = Smartlook.currentRenderingModeOption()

        let smartlookConfig = Smartlook.SetupConfiguration(key: Self.smartlookApiKey)
        smartlookConfig.renderingMode = renderingMode
        smartlookConfig.renderingModeOption = renderingModeOption
        smartlookConfig.framerate = Self.Rendering.framerate
        smartlookConfig.enableAdaptiveFramerate = Self.Rendering.useAdaptiveFramerate
        smartlookConfig.eventTrackingModes = Smartlook.currentEventTrackingModes() as NSArray

        return smartlookConfig
    }

    /// Updates Smartlook configuration with actual parameters.
    static func updateConfiguration() {
        let smartlookConfig = Self.smartlookConfig()
        update(configuration: smartlookConfig)
    }

    /// Updates Smartlook with given configuration.
    static func update(configuration: Smartlook.SetupConfiguration) {
        let isRecording = Smartlook.isRecording()

        // If we record, we will stop recording first
        if isRecording {
            Smartlook.stopRecording()
        }

        // We will set up a new configuration and restore the recording
        Smartlook.setup(configuration: configuration)

        if isRecording {
            Smartlook.stopRecording()
        }
    }
}