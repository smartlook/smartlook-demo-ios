//
//  DemoConfigurability.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 18.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import UIKit

protocol DemoConfigurability: UIViewController {
    var options: [DemoOption] { get set }
}
