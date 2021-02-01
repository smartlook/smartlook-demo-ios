//
//  StepperCell.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 18.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol StepperCellDelegate: AnyObject {
    func stepperCellValueChanged(sender: UIStepper)
}

class StepperCell: UITableViewCell {

    // MARK: - Inner types

    struct Content {
        let title: String?
        var value: Int

        init(value: Int) {
            self.init(title: nil, value: value)
        }

        init(title: String?, value: Int) {
            self.title = title
            self.value = value
        }
    }


    // MARK: - Outlets

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var valueStepper: UIStepper!


    // MARK: - Public

    weak var delegate: StepperCellDelegate?


    // MARK: - View setup

    public func setupContent(_ content: Content) {
        if let title = content.title {
            titleLabel.text = title
        }
        valueLabel.text = "\(content.value) " + "fps".localized
        valueStepper.value = Double(content.value)
    }


    // MARK: - UI Actions

    @IBAction private func valueStepperChanged(sender: UIStepper) {
        delegate?.stepperCellValueChanged(sender: sender)
    }
}
