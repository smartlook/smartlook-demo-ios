//
//  TownsHostingController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 18.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import SwiftUI

class TownsHostingController: UIHostingController<AnyView>, DemoConfigurability {

    // MARK: - Public

    var options: [DemoOption] = [DemoOption]() {
        didSet {
            demoOptions.items = options
        }
    }


    // MARK: - Private

    var demoOptions = TownsDemoOptions()


    // MARK: - Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AnyView(TownsView().environmentObject(demoOptions)))
    }
}
