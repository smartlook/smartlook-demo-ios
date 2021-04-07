//
//  ValueEditViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 18.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol ValueEditViewControllerDelegate: AnyObject {
    func didCloseValueEdit(id: String?, value: String?)
}

class ValueEditViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet private var valueTextField: UITextField!


    // MARK: - Public

    var id: String?
    var value: String?
    var footerTitle: String?

    weak var delegate: ValueEditViewControllerDelegate?


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        updateTable()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        valueTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            delegate?.didCloseValueEdit(id: id, value: value)
        }
    }


    // MARK: - Data update

    private func updateTable() {
        valueTextField.text = value
    }


    // MARK: - UI Actions

    @objc func textFieldDidChange(_ textField: UITextField) {
        value = textField.text
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard footerTitle != nil else {
            return super.tableView(tableView, titleForFooterInSection: section)
        }

        return footerTitle
    }


    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        valueTextField.becomeFirstResponder()
    }
}

extension ValueEditViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDidChange(textField)
        valueTextField.resignFirstResponder()

        // Pops back to previous view controller
        delegate?.didCloseValueEdit(id: id, value: value)
        navigationController?.popViewController(animated: true)

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidChange(textField)
    }
}
