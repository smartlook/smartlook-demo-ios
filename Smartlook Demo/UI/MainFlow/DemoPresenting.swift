//
//  DemoPresenting.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 05.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import UIKit

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

            present(viewController, animated: true, completion: nil)
        }
    }
}
