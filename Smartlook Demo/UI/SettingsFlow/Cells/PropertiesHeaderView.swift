//
//  PropertiesHeaderView.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 17.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

final class PropertiesHeaderView: UITableViewHeaderFooterView {

    // MARK: - Static constants

    static let reuseIdentifier: String = String(describing: self)


    // MARK: - Public

    var valueTextLabel = UILabel()


    // MARK: - Initialization

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: - View setup

    func setupView() {
        contentView.addSubview(valueTextLabel)

        valueTextLabel.font = .preferredFont(forTextStyle: .footnote)
        valueTextLabel.textColor = .secondaryLabel
        valueTextLabel.textAlignment = .right

        let layoutGuide = contentView.layoutMarginsGuide
        valueTextLabel.translatesAutoresizingMaskIntoConstraints = false
        valueTextLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        valueTextLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 1).isActive = true
    }
}
