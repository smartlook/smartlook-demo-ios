//
//  SelectionViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 08.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol SelectionViewControllerDelegate: AnyObject {
    func didChangedItem(inSelection selection: String?, withValue value: Any, to state: Bool)
}

class SelectionViewController: UITableViewController {

    // MARK: - Public

    var selectionData = SelectionData(id: nil)
    var allowMultipleSelection: Bool = false {
        didSet {
            tableView.allowsMultipleSelection = allowMultipleSelection
        }
    }

    weak var delegate: SelectionViewControllerDelegate?


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionData.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = selectionData.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath)
        cell.textLabel?.text = item.label.localized
        cell.accessoryType = item.selected ? .checkmark : .none

        return cell
    }


    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < selectionData.items.count else {
            return
        }

        let item = selectionData.items[indexPath.row]
        if allowMultipleSelection == false, item.selected {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        // Remove last selection
        deselectAllRows()

        if allowMultipleSelection {
            // Update checkmark for selected item
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = item.selected ? .none : .checkmark
            }
            selectionData.items[indexPath.row].selected.toggle()

        } else {
            // Checkmark only one item
            markExclusivelyRow(at: indexPath)
            deselectAllItems()
            selectionData.items[indexPath.row].selected = true
        }

        // Inform delegate about new selection
        delegate?.didChangedItem(inSelection: selectionData.id, withValue: item.value, to: !item.selected)
    }


    // MARK: - Table view utils

    private func deselectAllRows() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach { selectedPath in
                tableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }

    private func markExclusivelyRow(at indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                let addCheckmark = row == indexPath.row
                cell.accessoryType = addCheckmark ? .checkmark : .none
            }
        }
    }


    // MARK: - Data utils

    private func deselectAllItems() {
        for index in selectionData.items.indices {
            selectionData.items[index].selected = false
        }
    }
}
