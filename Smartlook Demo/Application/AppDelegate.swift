//
//  AppDelegate.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit
import Smartlook
import SmartlookConsentSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Private

    private let smartlookApiKey = "a76b285a70ecfb2b2cc13a13b0be2de6b60acf99"


    // MARK: - UIApplication lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Smartlook SDK
        let smartlookConfig = Smartlook.SetupConfiguration(key: smartlookApiKey)
        Smartlook.setup(configuration: smartlookConfig)

        // Smartlook Consent SDK
        var consentsSettingsDefaults = SmartlookConsentSDK.ConsentsSettings()
        consentsSettingsDefaults.append((.privacy, .provided))
        consentsSettingsDefaults.append((.analytics, .provided))

        SmartlookConsentSDK.check(with: consentsSettingsDefaults) {
            if SmartlookConsentSDK.consentState(for: .privacy) == .provided {
            //    Smartlook.startRecording()
            }
        }

        // Reuse apiKey for settings dialog
        SettingsData.smartlookApiKey = smartlookApiKey

//        // Settings store test
//        let manager = AppSettingsManager()
//        manager.save()
//        let appSettings = manager.load()

        return true
    }


    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after
        // application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
