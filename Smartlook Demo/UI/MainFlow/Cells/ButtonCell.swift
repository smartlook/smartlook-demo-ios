//
//  ButtonCell.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 07.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    // MARK: - Overrides

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        contentView.alpha = highlighted ? 0.6 : 1.0
    }
}
