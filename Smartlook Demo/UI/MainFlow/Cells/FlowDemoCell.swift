//
//  FlowDemoCell.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 14.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

class FlowDemoCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var technologyLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var iconBackgroundView: UIView!


    // MARK: - Overrides

    override var isHighlighted: Bool {
        didSet {
            let normalColor = UIColor.secondarySystemGroupedBackground
            let pressedColor = UIColor(named: "PressedCellColor")
            contentView.backgroundColor = isHighlighted ? pressedColor : normalColor
        }
    }


    // MARK: - View lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        // Updates rendering of cell shadow
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = cornerRadius
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }


    // MARK: - View setup

    public func setupContent(_ content: DemoItem) {
        nameLabel.text = content.nameLocalized
        technologyLabel.text = content.technology
        descriptionLabel.text = content.perexLocalized

        iconImageView.image = content.icon
        iconImageView.tintColor = .white
        iconBackgroundView.backgroundColor = content.iconColor
    }
}
