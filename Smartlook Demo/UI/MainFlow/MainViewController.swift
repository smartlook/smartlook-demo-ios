//
//  MainViewController.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 14.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import Smartlook

class MainViewController: UIViewController, DemoPresenting {

    // MARK: - Outlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    @IBOutlet private weak var shareButton: UIBarButtonItem!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionLayout.estimatedItemSize = CGSize(width: view.bounds.size.width - 36, height: 10)

        super.traitCollectionDidChange(previousTraitCollection)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionLayout.estimatedItemSize = CGSize(width: view.bounds.size.width - 36, height: 10)
        collectionLayout.invalidateLayout()

        super.viewWillTransition(to: size, with: coordinator)
    }


    // MARK: - View setup

    func configureView() {
        let backgroundImage = UIImage.init(named: "mainBackground")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .topLeft
        collectionView.backgroundView = imageView
    }


    // MARK: - Navigation

    private func showDemoDetail(for item: DemoItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController?

        // Load starting view controller
        viewController = storyboard.instantiateViewController(identifier: "DemoDetailScreen")

        if
            let navigationController = viewController as? UINavigationController,
            let demoDetailViewController = navigationController.viewControllers.first as? DemoDetailViewController {
            demoDetailViewController.item = item

            self.present(navigationController, animated: true, completion: nil)
        }
    }


    // MARK: - UI Actions

    @IBAction private func shareButtonAction(_ sender: UIBarButtonItem) {
        guard let dashboardSessionUrl = Smartlook.getDashboardSessionURL(withCurrentTimestamp: false) else {
            return
        }

        // Configure the desired behavior
        let activityViewController = UIActivityViewController(activityItems: [dashboardSessionUrl], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.postToFlickr, .postToVimeo]
        activityViewController.popoverPresentationController?.barButtonItem = shareButton

        // Present system share controller
        self.present(activityViewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource methods

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FlowDemoHeader",
                                                                         for: indexPath) as? FlowDemoHeaderView
        headerView?.delegate = self
        headerView?.setupContent(recording: Smartlook.isRecording())

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

extension MainViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - Collection View Flow Layout Delegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let guide = view.safeAreaLayoutGuide
        let safeAreaWidth = guide.layoutFrame.width
        let columns = max(1, floor(safeAreaWidth / 300))

        let insetsWidth = collectionLayout.sectionInset.left + collectionLayout.sectionInset.right
        let itemsSpacing = collectionLayout.minimumInteritemSpacing * (columns + 1)

        // Calculate minimal size for cell
        var fittingSize = UIView.layoutFittingCompressedSize
        let width = safeAreaWidth - insetsWidth - itemsSpacing
        fittingSize.width = width / columns

        return fittingSize
    }
}

extension MainViewController: FlowDemoHeaderViewDelegate {

    // MARK: - FlowDemoHeaderViewDelegate methods

    func recordingButtonPressed() {
        if Smartlook.isRecording() {
            Smartlook.stopRecording()
        } else {
            Smartlook.startRecording()
        }

        // Updates recording state in header
        collectionView.reloadData()
    }
}
