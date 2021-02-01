//
//  RenderingViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 08.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import Smartlook

class RenderingViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet private var modeCell: UITableViewCell!
    @IBOutlet private var optionCell: UITableViewCell!

    @IBOutlet private var adaptiveFramerateCell: SwitchCell!
    @IBOutlet private var framerateCell: StepperCell!


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        adaptiveFramerateCell.delegate = self
        framerateCell.delegate = self

        updateTable()
    }


    // MARK: - Data update

    private func updateTable() {
        tableView.reloadData()

        // Rendering section
        let renderingMode = SettingsData.Rendering.currentMode.rawValue
        modeCell.detailTextLabel?.text = renderingMode.localized

        if let renderingModeOption = SettingsData.Rendering.currentModeOption?.rawValue {
            optionCell.detailTextLabel?.text = renderingModeOption.localized
        }

        // Framerate section
        let useAdaptiveFramerate = SettingsData.Rendering.useAdaptiveFramerate
        adaptiveFramerateCell.setupContent(SwitchCell.Content(enabled: useAdaptiveFramerate))

        let framerateValue = SettingsData.Rendering.framerate
        framerateCell.setupContent(StepperCell.Content(value: framerateValue))
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let selectionViewController = segue.destination as? SelectionViewController {
            selectionViewController.delegate = self

            switch segue.identifier ?? "" {
            case "ShowRenderingMode":
                // Options for selection
                selectionViewController.selectionData = SettingsData.Rendering.modeItems
                selectionViewController.title = "rendering-mode".localized

            case "ShowRenderingOptions":
                // Options for selection
                selectionViewController.selectionData = SettingsData.Rendering.modeOptionItems
                selectionViewController.title = "rendering-option".localized

            default:
                break
            }
        }
    }


    // MARK: - UI Actions

    private func resetCurrentSession() {
        let smartlookConfig = SettingsData.smartlookConfig()
        smartlookConfig.resetSession = true
        SettingsData.update(configuration: smartlookConfig)

        // Notify user
        showAlert(title: "alert-session-reset", message: "alert-session-reset-message")
    }

    private func resetCurrentSessionAndUser() {
        let smartlookConfig = SettingsData.smartlookConfig()
        smartlookConfig.resetSessionAndUser = true
        SettingsData.update(configuration: smartlookConfig)

        // Notify user
        showAlert(title: "alert-session-reset", message: "alert-session-reset-message")
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return SettingsData.Rendering.currentMode == .wireframe ? 2 : 1
        }

        return super.tableView(tableView, numberOfRowsInSection: section)
    }


    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Rows in Session section
        if indexPath.section == 2 {
            tableView.deselectRow(at: indexPath, animated: false)

            switch indexPath.row {
            case 0:
                resetCurrentSession()
            case 1:
                resetCurrentSessionAndUser()
            default:
                break
            }
        }
    }


    // MARK: - Private methods

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "button-ok".localized, style: .default, handler: nil))

        present(alert, animated: true)
    }
}

extension RenderingViewController: SelectionViewControllerDelegate {

    // MARK: - SelectionViewControllerDelegate methods

    func didChangedItem(inSelection selection: String?, withValue value: Any, to state: Bool) {
        if let renderingMode = value as? Smartlook.RenderingMode {
            SettingsData.Rendering.currentMode = renderingMode

            // Track custom event about changing the rendering mode
            Smartlook.trackCustomEvent(name: "rendering-mode-changed".localized,
                                       props: ["newMode": renderingMode.rawValue])
        }

        if let renderingModeOption = value as? Smartlook.RenderingModeOption {
            SettingsData.Rendering.currentModeOption = renderingModeOption
        }
    }
}

extension RenderingViewController: SwitchCellDelegate {

    // MARK: - SwitchCellDelegate methods

    func switchCellValueChanged(sender: UISwitch) {
        SettingsData.Rendering.useAdaptiveFramerate = sender.isOn
    }
}

extension RenderingViewController: StepperCellDelegate {

    // MARK: - StepperCellDelegate methods

    func stepperCellValueChanged(sender: UIStepper) {
        SettingsData.Rendering.framerate = Int(sender.value)
        updateTable()
    }
}
