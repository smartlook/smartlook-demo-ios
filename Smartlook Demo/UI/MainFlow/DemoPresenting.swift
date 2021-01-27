//
//  DemoPresenting.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 05.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import UIKit
import Smartlook

protocol DemoPresenting: UIViewController {
    func showDemo(for item: DemoItem)
}


extension DemoPresenting {

    func showDemo(for item: DemoItem) {
        let storyboard = UIStoryboard(name: item.storyboardName, bundle: nil)
        let viewController: UIViewController?

        // Load starting view controller
        if let storyboardId = item.storyboardId {
            viewController = storyboard.instantiateViewController(identifier: storyboardId)
        } else {
            viewController = storyboard.instantiateInitialViewController()
        }

        // Show as independent flow
        if let viewController = viewController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .flipHorizontal

            // We will pass demo options
            if
                let demoDetail = item.detail,
                let demoOptions = demoDetail.options,
                let configurableViewController = viewController as? DemoConfigurability
            {
                configurableViewController.options = demoOptions
            }

            // Our custom view controller identification
            let viewControllerId = item.nameLocalized + " (\(item.id))"

            // We can also track the execution of any navigation
            // manually as in the following code
            present(viewController, animated: true) {
                // Track exit from transition
                Smartlook.trackNavigationEvent(withControllerId: viewControllerId, type: .exit)
            }

            // Track enter to transition
            Smartlook.trackNavigationEvent(withControllerId: viewControllerId, type: .enter)
        }
    }
}
