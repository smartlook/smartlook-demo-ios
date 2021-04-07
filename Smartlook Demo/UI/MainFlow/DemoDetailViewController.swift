//
//  DemoDetailViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 05.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import UIKit

class DemoDetailViewController: UITableViewController, DemoPresenting {

    // MARK: - Public

    var item: DemoItem?


    // MARK: - Private

    private var sections = [String]()
    private var rows = [Int: [Any]]()


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        prepareData()
    }


    // MARK: - View setup

    private func configureView() {
        let backgroundImage = UIImage(named: "mainBackground")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .topLeft
        imageView.alpha = 0.25
        tableView.backgroundView = imageView

        title = item?.nameLocalized
    }


    // MARK: - Data preparation

    private func prepareData() {
        guard let demoItem = item, let detail = demoItem.detail else {
            return
        }

        if detail.showNotes {
            addSection(withTitle: "demo-notes".localized, rows: [demoItem.notesLocalized ?? ""])
        }

        if detail.showDeveloperNotes {
            addSection(withTitle: "developer-notes".localized, rows: [demoItem.developerNotesLocalized ?? ""])
        }

        if let options = detail.options, !options.isEmpty {
            addSection(withTitle: "options".localized, rows: options)
        }

        addSection(withTitle: " ", rows: ["show-demo".localized])
    }

    private func addSection(withTitle title: String, rows: [Any]) {
        sections.append(title)
        self.rows[sections.count - 1] = rows
    }


    // MARK: - UI Actions

    @IBAction private func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = rows[section] else {
            return 0
        }

        return rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowData = rows[indexPath.section]?[indexPath.row] else {
            return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }

        var cell: UITableViewCell?

        // Notes sections
        if
            let note = rowData as? String,
            indexPath.section != sections.count - 1
        {
            let notesCell = tableView.dequeueReusableCell(withIdentifier: "DemoDetailNotesCell", for: indexPath)
            notesCell.textLabel?.text = note
            cell = notesCell
        }

        // Option section
        if let option = rowData as? DemoOption {
            let optionCell = tableView.dequeueReusableCell(withIdentifier: "DemoDetailOptionCell", for: indexPath)
            optionCell.textLabel?.text = option.nameLocalized
            optionCell.accessoryType = option.enabled ? .checkmark : .none
            cell = optionCell
        }

        // Last section with button
        if
            let title = rowData as? String,
            indexPath.section == sections.count - 1
        {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell
            buttonCell?.textLabel?.text = title
            buttonCell?.contentView.backgroundColor = item?.iconColor
            cell = buttonCell
        }

        return cell!
    }


    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Option rows
        if rows[indexPath.section]?[indexPath.row] as? DemoOption != nil {
            tableView.deselectRow(at: indexPath, animated: true)
            item?.detail?.options?[indexPath.row].enabled.toggle()

            // Update checkmark for selected item
            if let cell = tableView.cellForRow(at: indexPath) {
                let enabled = item?.detail?.options?[indexPath.row].enabled ?? false
                cell.accessoryType = enabled ? .checkmark : .none
            }
        }

        // Show demo row
        if indexPath.section == sections.count - 1 {
            if let demoItem = item {
                showDemo(for: demoItem)
            }
        }
    }
}
