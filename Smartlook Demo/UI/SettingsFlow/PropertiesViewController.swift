//
//  PropertiesViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 17.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol PropertiesViewControllerDelegate: AnyObject {
    func didChangedPropertiesData(_ propertiesData: PropertiesData)
}

class PropertiesViewController: UITableViewController {

    // MARK: - Public

    var properties = PropertiesData(id: nil)
    weak var delegate: PropertiesViewControllerDelegate?


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        tableView.register(PropertiesHeaderView.self, forHeaderFooterViewReuseIdentifier: PropertiesHeaderView.reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)

        super.viewWillDisappear(animated)
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let propertyEditViewController = segue.destination as? PropertyEditViewController {
            propertyEditViewController.delegate = self

            switch segue.identifier ?? "" {
            case "ShowAddProperty":
                propertyEditViewController.property = PropertyItem()
                propertyEditViewController.title = "new-property".localized

            case "ShowEditProperty":
                if
                    let index = tableView.indexPathForSelectedRow?.row,
                    index < properties.items.count
                {
                    propertyEditViewController.property = properties.items[index]
                }
                propertyEditViewController.title = "edit-property".localized

            default:
                break
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if properties.items.isEmpty {
            tableView.showEmptyView(title: "no-properties-defined".localized,
                                    message: "your-properties-add-here".localized)
        } else {
            tableView.hideEmptyView()
        }

        return min(1, properties.items.count)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertiesCell", for: indexPath)

        if indexPath.row < properties.items.count {
            let property = properties.items[indexPath.row]
            cell.textLabel?.text = property.name
            cell.detailTextLabel?.text = property.value
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove item and inform delegate about new state
            properties.items.remove(at: indexPath.row)
            delegate?.didChangedPropertiesData(properties)

            if properties.items.isEmpty {
                tableView.deleteSections([indexPath.section], with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "name".localized
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PropertiesHeaderView.reuseIdentifier) as? PropertiesHeaderView
        else {
            return nil
        }

        view.valueTextLabel.text = "value".localized.uppercased()

        return view
    }
}

extension PropertiesViewController: PropertyEditViewControllerDelegate {

    // MARK: - PropertyEditViewControllerDelegate methods

    func didSaveButtonPressed(editedProperty: PropertyItem, original: PropertyItem?) {
        if let original = original, original.isValid() {
            // Property exists, we it update
            for (index, property) in properties.items.enumerated() where property == original {
                properties.items[index] = editedProperty
            }
        } else {
            // New property
            properties.items.append(editedProperty)
        }

        // Update view and inform delegate about new state
        tableView.reloadData()
        delegate?.didChangedPropertiesData(properties)
    }
}
