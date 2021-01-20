//
//  SwitchCell.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 18.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: AnyObject {
    func switchCellValueChanged(sender: UISwitch)
}

class SwitchCell: UITableViewCell {

    // MARK: - Inner types

    struct Content {
        let title: String?
        var enabled: Bool

        init(enabled: Bool) {
            self.init(title: nil, enabled: enabled)
        }

        init(title: String?, enabled: Bool) {
            self.title = title
            self.enabled = enabled
        }
    }


    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueSwitch: UISwitch!


    // MARK: - Public

    weak var delegate: SwitchCellDelegate?


    // MARK: - View setup

    public func setupContent(_ content: Content) {
        if let title = content.title {
            titleLabel.text = title
        }
        valueSwitch.isOn = content.enabled
    }


    // MARK: - UI Actions

    @IBAction private func valueSwitchChanged(sender: UISwitch) {
        delegate?.switchCellValueChanged(sender: sender)
    }
}
