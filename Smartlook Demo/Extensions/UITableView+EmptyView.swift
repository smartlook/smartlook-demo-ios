//
//  UITableView+EmptyView.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 07.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import UIKit

extension UITableView {

    func showEmptyView(title: String, message: String? = nil) {

        let titleLabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = .preferredFont(forTextStyle: .subheadline)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let emptyView = UIView(frame: CGRect(origin: .zero, size: bounds.size))
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)

        // Set constraints
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true

        // Fill data
        titleLabel.text = title
        messageLabel.text = message

        // Add empty view
        backgroundView = emptyView
    }

    func hideEmptyView() {
        // Remove empty view
        backgroundView = nil
    }
}
