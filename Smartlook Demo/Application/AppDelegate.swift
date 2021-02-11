//
//  AppDelegate.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import Smartlook
import SmartlookConsentSDK
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Private

    // TODO: Insert your project SDK Key to this place!
    /// It is used as an initialization api key. If set, the application
    /// does not require the setting of the api key. The key defined in
    /// this way can also be changed in the application settings.
    private let smartlookApiKey = ""


    // MARK: - UIApplication lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Reuse apiKey for settings dialog
        SettingsData.smartlookApiKey = smartlookApiKey
        AppSettingsManager().sync()

        // Smartlook SDK
        let smartlookConfig = Smartlook.SetupConfiguration(key: smartlookApiKey)
        Smartlook.setup(configuration: smartlookConfig)

        // Smartlook Consent SDK
        var consentsSettingsDefaults = SmartlookConsentSDK.ConsentsSettings()
        consentsSettingsDefaults.append((.privacy, .provided))
        consentsSettingsDefaults.append((.analytics, .provided))

        SmartlookConsentSDK.check(with: consentsSettingsDefaults) {
            if
                SmartlookConsentSDK.consentState(for: .privacy) == .provided,
                SettingsData.isApiKeyValid
            {
                Smartlook.startRecording()
            }
        }

        return true
    }


    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
