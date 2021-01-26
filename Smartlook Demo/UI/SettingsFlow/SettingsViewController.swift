//
//  SettingsViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 08.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import Smartlook
import SmartlookConsentSDK

class SettingsViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet private weak var renderingCell: UITableViewCell!

    @IBOutlet private weak var denyListCell: UITableViewCell!
    @IBOutlet private weak var userIdentificationCell: UITableViewCell!
    @IBOutlet private weak var sessionPropertiesCell: UITableViewCell!

    @IBOutlet private weak var eventTrackingCell: UITableViewCell!
    @IBOutlet private weak var globalPropertiesCell: UITableViewCell!


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateTable()
    }


    // MARK: - Data update

    private func updateTable() {
        // Record section
        let renderingMode = SettingsData.Rendering.currentMode.rawValue
        renderingCell.detailTextLabel?.text = renderingMode.localized

        // Privacy section
        let denyListCount = SettingsData.Privacy.denyList.selectedValues().count
        denyListCell.detailTextLabel?.text = "\(denyListCount)"

        let userIdentification = SettingsData.Privacy.userIdentifier ?? "None"
        let isValueGray = userIdentification == "none".localized
        userIdentificationCell.detailTextLabel?.text = userIdentification
        userIdentificationCell.detailTextLabel?.textColor = isValueGray ? .secondaryLabel : .label

        let sessionPropertiesCount = SettingsData.Privacy.sessionProperties.items.count
        sessionPropertiesCell.detailTextLabel?.text = "\(sessionPropertiesCount)"

        // Analytics section
        let eventTrackingModes = SettingsData.Analytics.eventTrackingModeItems
        eventTrackingCell.detailTextLabel?.text = textValue(for: eventTrackingModes)

        let globalPropertiesCount = SettingsData.Analytics.globalProperties.items.count
        globalPropertiesCell.detailTextLabel?.text = "\(globalPropertiesCount)"
    }


    // MARK: - Data preparation

    private func textValue(for eventTrackingModes: SelectionData) -> String {
        let selected = eventTrackingModes.selected()
        if selected.isEmpty {
            return "event-tracking-mode-full".localized
        }

        return "\(selected.count) " + "ignored".localized
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let selectionViewController = segue.destination as? SelectionViewController {
            selectionViewController.delegate = self
            selectionViewController.allowMultipleSelection = true

            // Fills options for current selection
            switch segue.identifier ?? "" {
            case "ShowDenyList":
                selectionViewController.selectionData = SettingsData.Privacy.denyList
                selectionViewController.title = "settings-deny-list".localized

            case "ShowEventTrackingModes":
                selectionViewController.selectionData = SettingsData.Analytics.eventTrackingModeItems
                selectionViewController.title = "settings-event-tracking".localized

            default:
                break
            }
        }

        if let propertiesViewController = segue.destination as? PropertiesViewController {
            propertiesViewController.delegate = self

            // Fills properties for corresponding section
            switch segue.identifier ?? "" {
            case "ShowSessionProperties":
                propertiesViewController.properties = SettingsData.Privacy.sessionProperties
                propertiesViewController.title = "session-properties".localized

            case "ShowGlobalProperties":
                propertiesViewController.properties = SettingsData.Analytics.globalProperties
                propertiesViewController.title = "global-properties".localized

            default:
                break
            }
        }

        if let valueEditViewController = segue.destination as? ValueEditViewController {
            valueEditViewController.delegate = self
            valueEditViewController.value = SettingsData.Privacy.userIdentifier
        }
    }


    // MARK: - UI Actions

    @IBAction private func doneButtonAction(_ sender: Any) {
        AppSettingsManager().save()
        dismiss(animated: true)
    }

    private func reviewConsents() {
        // Let user review or check the consents
        SmartlookConsentSDK.show {
            if SmartlookConsentSDK.consentState(for: .privacy) != .provided {
                // Stop analytics tools
                Smartlook.stopRecording()
            }
        }
    }


    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Consent row
        if indexPath.section == 3 {
            tableView.deselectRow(at: indexPath, animated: false)
            reviewConsents()
        }
    }
}

extension SettingsViewController: SelectionViewControllerDelegate {

    // MARK: - SelectionViewControllerDelegate methods

    func didChangedItem(inSelection selection: String?, withValue value: Any, to state: Bool) {
        switch selection {
        case "privacyDenyList":
            updateItem(in: &SettingsData.Privacy.denyList, forValue: value, to: state)

        case "eventTrackingModes":
            if let eventTrackingMode = value as? Smartlook.EventTrackingMode {
                updateItem(in: &SettingsData.Analytics.eventTrackingModeItems, forValue: eventTrackingMode, to: state)
            }

        default:
            break
        }
    }


    // MARK: - SelectionData update helpers

    func updateItem(in selectionData: inout SelectionData, forValue value: Any, to state: Bool) {
        for (index, item) in selectionData.items.enumerated() {
            if String(describing: item.value) == String(describing: value) {
                selectionData.items[index].selected = state
            }
        }
    }

    func updateItem<T: Equatable>(in selectionData: inout SelectionData, forValue value: T, to state: Bool) {
        for (index, item) in selectionData.items.enumerated() {
            if
                let itemValue = item.value as? T,
                itemValue == value
            {
                selectionData.items[index].selected = state
            }
        }
    }
}

extension SettingsViewController: ValueEditViewControllerDelegate {

    // MARK: - ValueEditViewControllerDelegate methods

    func didCloseValueEdit(value: String?) {
        SettingsData.Privacy.userIdentifier = value
    }
}

extension SettingsViewController: PropertiesViewControllerDelegate {

    // MARK: - PropertiesViewControllerDelegate methods

    func didChangedPropertiesData(_ propertiesData: PropertiesData) {
        switch propertiesData.id {
        case SettingsData.Privacy.sessionProperties.id:
            SettingsData.Privacy.sessionProperties = propertiesData

        case SettingsData.Analytics.globalProperties.id:
            SettingsData.Analytics.globalProperties = propertiesData

        default:
            break
        }
    }
}
