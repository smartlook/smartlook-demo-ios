//
//  DetailViewController.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!


    // MARK: - Public

    var town: Town? {
        didSet(newValue) {
            if newValue != town {
                configureView()
            }
        }
    }

    var isMapSensitive = false


    // MARK: - Private

    private var loadingObserver: NSKeyValueObservation?


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        loadingObserver = webView.observe(\.isLoading, options: [.new]) { [unowned self] object, _ in
            if object == self.webView {
                if self.webView.isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }

        configureView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        loadingObserver = nil
    }


    // MARK: - View setup

    func configureView() {
        // Update the user interface for the detail item.
        if town == nil {
            town = TownsData.all.first
        }
        navigationItem.title = town?.name

        if let townUrl = town?.url, webView != nil {
            let request = URLRequest(url: townUrl)
            webView.load(request)
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            let destination = segue.destination as? MapController
            destination?.town = town
            destination?.view.slSensitive = isMapSensitive
        }
    }
}
