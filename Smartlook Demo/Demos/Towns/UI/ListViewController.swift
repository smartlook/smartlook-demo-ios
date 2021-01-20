//
//  ListViewController.swift
//  Smartlook Demo App
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit
import Smartlook

class ListViewController: UITableViewController {

    private var searchController: UISearchController?
    private var filterTerm: String?


    // MARK: - Public

    var trackSelection = true


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false
        searchController?.searchBar.text = filterTerm
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let indexPath = tableView.indexPathForSelectedRow

            let navigationController = segue.destination as? UINavigationController
            let controller = navigationController?.topViewController as? DetailViewController
            controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller?.navigationItem.leftItemsSupplementBackButton = true

            let town = filteredData()[indexPath?.item ?? 0]
            controller?.town = town

            if trackSelection {
                Smartlook.trackCustomEvent(name: "townSelected", props: ["name": town.name ?? ""])
            }
        }
    }


    // MARK: - UI Actions

    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }


    // MARK: - Data

    func filteredData() -> [Town] {
        TownsData.filtered(by: filterTerm)
    }


    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TownCell", for: indexPath) as? TownCell
        let data = filteredData()

        if indexPath.row < data.count {
            let town = data[indexPath.row]
            cell?.name?.text = town.name
            cell?.flag?.image = town.flag
        }

        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
}


extension ListViewController: UISearchResultsUpdating {

    // MARK: - UISearchResultsUpdating methods

    func updateSearchResults(for searchController: UISearchController) {
        filterTerm = self.searchController?.searchBar.text
        tableView.reloadData()
    }
}
