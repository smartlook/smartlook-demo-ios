//
//  PropertyEditViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 18.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol PropertyEditViewControllerDelegate: AnyObject {
    func didSaveButtonPressed(editedProperty: PropertyItem, original: PropertyItem?)
}

class PropertyEditViewController: UITableViewController {

    // MARK: - Static constants

    private enum Identifiers {
        static let name = "name"
        static let value = "value"
    }


    // MARK: - Outlets

    @IBOutlet private var saveButton: UIBarButtonItem!

    @IBOutlet private var nameCell: PropertyEditCell!
    @IBOutlet private var valueCell: PropertyEditCell!


    // MARK: - Public

    var property: PropertyItem? {
        didSet {
            editedProperty = property
        }
    }

    weak var delegate: PropertyEditViewControllerDelegate?


    // MARK: - Private

    private var editedProperty: PropertyItem?


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameCell.delegate = self
        valueCell.delegate = self

        updateTable()
    }


    // MARK: - Data update

    private func updateTable() {
        // Definition section
        let nameCellContent = PropertyEditCell.Content(id: Identifiers.name, value: property?.name)
        nameCell.setupContent(nameCellContent)

        let valueCellContent = PropertyEditCell.Content(id: Identifiers.value, value: property?.value)
        valueCell.setupContent(valueCellContent)
    }


    // MARK: - UI Actions

    @IBAction private func saveButtonAction(_ sender: Any) {
        if
            let editedProperty = editedProperty,
            editedProperty != property
        {
            delegate?.didSaveButtonPressed(editedProperty: editedProperty, original: property)
        }

        navigationController?.popViewController(animated: true)
    }


    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PropertyEditCell {
            _ = cell.becomeFirstResponder()
        }
    }
}

extension PropertyEditViewController: PropertyEditCellDelegate {

    // MARK: - PropertyEditCellDelegate methods

    func propertyEditCellValueChanged(id: String, value: String?) {
        switch id {
        case Identifiers.name:
            if let name = value {
                editedProperty?.name = name
            }

        case Identifiers.value:
            if let value = value {
                editedProperty?.value = value
            }

        default:
            break
        }

        // Enables save button
        saveButton.isEnabled = editedProperty?.isValid() ?? false
    }

    func propertyEditCellFocusNext(afterId: String) {
        _ = valueCell.becomeFirstResponder()
    }

    func propertyEditDone() {
        if let button = saveButton, button.isEnabled {
            view.resignFirstResponder()
            saveButtonAction(button)
        }
    }
}
