//
//  SceneDelegate.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Public

    var window: UIWindow?


    // MARK: - Private

    private let storyboard = UIStoryboard(name: "Main", bundle: nil)


    // MARK: - UIWindowSceneDelegate methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        // Process the init URL
        if let url = connectionOptions.urlContexts.first?.url {
            _ = process(url: url)
        }

        // If we do not have an API key defined, we will show onboarding
        if
            SettingsData.smartlookApiKey?.isEmpty ?? true,
            let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingScreen") as? OnboardingViewController
        {
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = onboardingViewController
            window?.makeKeyAndVisible()
        }

        // Set global tint
        window?.tintColor = UIColor(named: "AppTintColor")
        UIView.appearance().tintColor = UIColor(named: "AppTintColor")
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else {
            return
        }

        // Process the URL
        if process(url: urlContext.url) {
            // Notify other screens
            let notificationName = SettingsData.smartlookApiKeyUpdatedNotification
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }


    // MARK: - Custom URL processing

    private func process(url: URL) -> Bool {
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host, host == "init",
              let params = components.queryItems,
              let sdkParam = params.first?.name, sdkParam == "sdk",
              let sdkKey = params.first?.value, !sdkKey.isEmpty
        else {
            return false
        }

        // Process SDK Key
        let apiKey = sdkKey.replacingOccurrences(of: "\"", with: "")
        if !apiKey.isEmpty {
            // Updates actual configuration with new key
            AppSettingsManager().sync(withNewApiKey: apiKey)

            return true
        }

        return false
    }
}
