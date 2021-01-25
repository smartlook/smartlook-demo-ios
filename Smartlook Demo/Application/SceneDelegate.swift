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


    // MARK: - UIWindowSceneDelegate methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Set global tint
        window?.tintColor = UIColor(named: "AppTintColor")
        UIView.appearance().tintColor = UIColor(named: "AppTintColor")
    }
}
