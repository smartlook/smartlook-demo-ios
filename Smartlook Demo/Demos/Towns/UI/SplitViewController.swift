//
//  SplitViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 14.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, DemoConfigurability {

    // MARK: - Public

    var options = [DemoOption]()


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let listNavigationController = viewControllers.first as? UINavigationController,
              let listController = listNavigationController.topViewController as? ListViewController
        else {
            return
        }

        guard let navigationController = viewControllers.last as? UINavigationController,
              let detailViewController = navigationController.topViewController as? DetailViewController
        else {
            return
        }

        // SplitView is a delegate to itself
        delegate = self

        // Pass options to view controllers
        let trackSelection = options.filter { $0.id == "track-town-selection" }.first?.enabled
        let isMapSensitive = options.filter { $0.id == "map-sensitivity" }.first?.enabled
        listController.trackSelection = trackSelection ?? true
        listController.isMapSensitive = isMapSensitive ?? false

        // Add the display mode button to the navigation bar
        detailViewController.navigationItem.leftBarButtonItem = displayModeButtonItem
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
    }
}


extension SplitViewController: UISplitViewControllerDelegate {

    // MARK: - UISplitViewControllerDelegate methods

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {

        guard let navigationController = secondaryViewController as? UINavigationController,
              let detailViewController = navigationController.topViewController as? DetailViewController
        else {
            // Fallback to the default
            return false
        }

        // Once we have something to show in the detail
        return detailViewController.town == nil
    }
}

extension UISplitViewController {

    // MARK: - Primary controller

    var primaryViewController: UIViewController? {
        viewControllers.first
    }
}
