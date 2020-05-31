//
//  MasterTableViewController.swift
//  SearchController
//
//  Created by Denis Abramov on 26.05.2020.
//  Copyright © 2020 Denis Abramov. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var candies: [Candy] = []
    var filteredCandies: [Candy] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        candies = Candy.candies()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = Candy.Category.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCandies.count
        }
        return candies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let candy: Candy
        
        if isFiltering() {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }

        cell.textLabel?.text = candy.name
        cell.detailTextLabel?.text = candy.category.rawValue

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailSegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
        else {
            return
        }
        
        let candy: Candy

        if isFiltering() {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        detailViewController.candy = candy
    }
    
    // MARK: - Search Controller
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    category: Candy.Category? = nil) {
        filteredCandies = candies.filter { (candy: Candy) -> Bool in
            let doesCategoryMatch = category == .all || candy.category == category
            
            if isSearchBarEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased()
                    .contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = Candy.Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}

extension MasterTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Candy.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}
