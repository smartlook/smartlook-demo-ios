//
//  PropertyEditCell.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 28.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol PropertyEditCellDelegate: AnyObject {
    func propertyEditCellValueChanged(id: String, value: String?)
    func propertyEditCellFocusNext(afterId: String)
    func propertyEditDone()
}

class PropertyEditCell: UITableViewCell {

    // MARK: - Inner types

    struct Content {
        let id: String
        let title: String?
        let placeholder: String?
        var value: String?

        init(id: String, title: String? = nil, placeholder: String? = nil, value: String? = nil) {
            self.id = id
            self.title = title
            self.placeholder = placeholder
            self.value = value
        }
    }


    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField!


    // MARK: - Public

    private(set) var content: Content?
    weak var delegate: PropertyEditCellDelegate?


    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }


    // MARK: - View setup

    public func setupContent(_ content: Content) {
        if let title = content.title {
            titleLabel.text = title
        }
        if let placeholder = content.placeholder {
            valueTextField.placeholder = placeholder
        }

        valueTextField.placeholder = content.placeholder
        valueTextField.text = content.value

        self.content = content
    }

    override func becomeFirstResponder() -> Bool {
        valueTextField.becomeFirstResponder()

        return true
    }


    // MARK: - UI Actions

    @objc func textFieldDidChange(_ textField: UITextField) {
        content?.value = textField.text

        if let content = content {
            delegate?.propertyEditCellValueChanged(id: content.id, value: content.value)
        }
    }
}

extension PropertyEditCell: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidChange(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if
            let content = content,
            textField.returnKeyType == .next
        {
            delegate?.propertyEditCellFocusNext(afterId: content.id)
        }

        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            delegate?.propertyEditDone()
        }

        return true
    }
}
