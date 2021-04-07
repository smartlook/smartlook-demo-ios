//
//  OnboardingViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 09.02.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var apiKeyTextField: UITextField!
    @IBOutlet private var setupButton: UIButton!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!


    // MARK: - Private

    private var keyWindow: UIWindow? {
        UIApplication.shared.windows.filter {
            $0.isKeyWindow
        }.first
    }

    private var isApiKeyValid: Bool {
        !(apiKeyTextField.text?.isEmpty ?? true)
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()


        let notificationCenter = NotificationCenter.default
        configureView()

        // API Key notification
        let notificationName = SettingsData.smartlookApiKeyUpdatedNotification
        _ = notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { _ in
            // API Key was updated, we move to main screen
            self.showMainScreen()
        }

        // Keyboard notifications
        notificationCenter.addObserver(
            self, selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )

        notificationCenter.addObserver(
            self, selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil
        )
    }


    // MARK: - View setup

    private func configureView() {
        apiKeyTextField.delegate = self
        apiKeyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        setupButton.isEnabled = false
        setupButton.alpha = 0.7
    }


    // MARK: - Navigation

    private func showMainScreen() {
        guard let window = keyWindow else {
            return
        }

        // Set main screen as new rootViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "MainScreen")
        window.rootViewController = rootViewController

        // Performs transition animation
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
    }


    // MARK: - UI Actions

    @IBAction private func setupButtonPressed() {
        AppSettingsManager().sync(withNewApiKey: apiKeyTextField.text)
        showMainScreen()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        setupButton.isEnabled = isApiKeyValid
        setupButton.alpha = isApiKeyValid ? 1.0 : 0.7
    }
}

extension OnboardingViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        apiKeyTextField.resignFirstResponder()

        return isApiKeyValid
    }
}


extension OnboardingViewController {

    // MARK: - Keyboard hiding

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            // Reset bottom constraint
            bottomConstraint.constant = 0

            // Animate change
            let duration = grabAnimationDuration(notification)
            UIView.animate(withDuration: duration, animations: { [self] in
                view.layoutIfNeeded()
            })

        } else {
            // Update bottom constraint
            bottomConstraint.constant = -(keyboardViewEndFrame.height - view.safeAreaInsets.bottom)

            // Animate change
            let duration = grabAnimationDuration(notification)
            UIView.animate(withDuration: duration, animations: { [self] in
                view.layoutIfNeeded()
            })
        }
    }

    private func grabAnimationDuration(_ notification: Notification?) -> TimeInterval {
        let userInfo = notification?.userInfo
        let duration = TimeInterval((userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0)

        return duration
    }
}
