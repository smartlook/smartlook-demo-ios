//
//  MainViewController.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 14.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import Smartlook
import SmartlookConsentSDK

class MainViewController: UIViewController, DemoPresenting {

    // MARK: - Outlets

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var shareButton: UIBarButtonItem!


    // MARK: - Private

    private var hasConsent: Bool {
        SmartlookConsentSDK.consentState(for: .privacy) == .provided
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // This is not necessary if all the logic is handled in the `SmartlookConsentSDK.check`
        // or `SmartlookConsentSDK.show` callbacks may be usefully eg.,
        // if some UI depends on the consents state like here.
        let notificationName = SmartlookConsentSDK.consentsTouchedNotification
        _ = NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { _ in
            // Updates recording state in header
            self.collectionView.reloadData()
        }

        configureView()
    }


    // MARK: - View setup

    func configureView() {
        let backgroundImage = UIImage(named: "mainBackground")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .topLeft
        collectionView.backgroundView = imageView

        collectionView.collectionViewLayout = createCompositionalLayout()
    }

    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { (_, environment) -> NSCollectionLayoutSection? in
            let itemsPerRow = environment.traitCollection.horizontalSizeClass == .compact ? 1 : 2
            let fraction: CGFloat = 1 / CGFloat(itemsPerRow)

            // Demo item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction),
                                                  heightDimension: .estimated(105))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(4)

            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 16, trailing: 0)
            section.interGroupSpacing = 12

            // Section header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(300))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [headerItem]

            return section
        })
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if
            let identifier = segue.identifier, identifier == "ShowSettings",
            let navigationController = segue.destination as? UINavigationController
        {
            navigationController.presentationController?.delegate = self
        }
    }

    private func showDemoDetail(for item: DemoItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController?

        // Load starting view controller
        viewController = storyboard.instantiateViewController(identifier: "DemoDetailScreen")

        if
            let navigationController = viewController as? UINavigationController,
            let demoDetailViewController = navigationController.viewControllers.first as? DemoDetailViewController
        {
            demoDetailViewController.item = item
            self.present(navigationController, animated: true, completion: nil)
        }
    }

    private func reviewConsents() {
        // Let user review or check the consents
        SmartlookConsentSDK.show {
            if SmartlookConsentSDK.consentState(for: .privacy) != .provided {
                // Stop analytics tools
                Smartlook.stopRecording()
            }

            // Track custom event about consent issue
            Smartlook.trackCustomEvent(name: "review-consent".localized, props: ["source": "Dashboard"])
        }
    }


    // MARK: - UI Actions

    @IBAction private func shareButtonAction(_: UIBarButtonItem) {
        guard let dashboardSessionUrl = Smartlook.getDashboardSessionURL(withCurrentTimestamp: false) else {
            return
        }

        // Configure the desired behavior
        let activityViewController = UIActivityViewController(activityItems: [dashboardSessionUrl], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.postToFlickr, .postToVimeo]
        activityViewController.popoverPresentationController?.barButtonItem = shareButton

        // Present system share controller
        present(activityViewController, animated: true)
    }
}

extension MainViewController: UIAdaptivePresentationControllerDelegate {

    // MARK: - UIAdaptivePresentationControllerDelegate methods

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        AppSettingsManager().save()
    }
}

extension MainViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource methods

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FlowDemoHeader",
                                                                         for: indexPath) as? FlowDemoHeaderView
        headerView?.delegate = self
        headerView?.setupContent(recording: Smartlook.isRecording(), consent: hasConsent)

        return headerView!
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DemosData.all.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "FlowDemoCell", for: indexPath) as? FlowDemoCell
        let data = DemosData.all

        if indexPath.row < data.count {
            let demoItem = data[indexPath.row]
            cell?.setupContent(demoItem)
        }

        return cell!
    }
}

extension MainViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < DemosData.all.count else {
            return
        }

        let demoItem = DemosData.all[indexPath.row]

        // Show demo or its detail
        if demoItem.detail == nil {
            showDemo(for: demoItem)
        } else {
            showDemoDetail(for: demoItem)
        }
    }
}

extension MainViewController: FlowDemoHeaderViewDelegate {

    // MARK: - FlowDemoHeaderViewDelegate methods

    func recordingButtonPressed() {
        guard hasConsent else {
            reviewConsents()
            return
        }

        // Consent allows start recording
        if Smartlook.isRecording() {
            Smartlook.stopRecording()
        } else {
            Smartlook.startRecording()
        }

        // Updates recording state in header
        collectionView.reloadData()
    }
}
