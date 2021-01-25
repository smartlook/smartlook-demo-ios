//
//  UIView+CornerRadius.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 14.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
