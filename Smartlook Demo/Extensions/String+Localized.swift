//
//  String+Localized.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 28.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, value: "", comment: "")
    }
}
