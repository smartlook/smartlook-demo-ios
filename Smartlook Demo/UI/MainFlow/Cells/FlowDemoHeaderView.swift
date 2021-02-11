//
//  FlowDemoHeaderView.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 17.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

protocol FlowDemoHeaderViewDelegate: AnyObject {
    func recordingButtonPressed()
}

class FlowDemoHeaderView: UICollectionReusableView {

    // MARK: - Outlets

    @IBOutlet private var sdkStateLabel: UILabel!
    @IBOutlet private var recordingButton: UIButton!


    // MARK: - Public

    weak var delegate: FlowDemoHeaderViewDelegate?


    // MARK: - View setup

    public func setupContent(recording: Bool, consent: Bool, key: Bool) {
        guard key else {
            let buttonImage = UIImage(systemName: "key.fill")
            recordingButton.setImage(buttonImage, for: .normal)
            recordingButton.imageView?.tintColor = .systemRed
            sdkStateLabel.text = "apiKey-issue".localized

            return
        }

        guard consent else {
            let buttonImage = UIImage(systemName: "person.circle")
            recordingButton.setImage(buttonImage, for: .normal)
            recordingButton.imageView?.tintColor = .systemRed
            sdkStateLabel.text = "consent-issue".localized

            return
        }

        // The user has given his consent to the use of analytical functions
        let recordingText = "sdk-recording".localized
        let suspendedText = "sdk-suspended".localized
        sdkStateLabel.text = recording ? recordingText : suspendedText

        let buttonImageName = recording ? "stop.circle.fill" : "record.circle"
        let buttonImage = UIImage(systemName: buttonImageName)
        recordingButton.setImage(buttonImage, for: .normal)
        recordingButton.imageView?.tintColor = .systemRed
    }


    // MARK: - UI Actions

    @IBAction private func recordingButtonValueChanged(_: UIButton) {
        delegate?.recordingButtonPressed()
    }
}
