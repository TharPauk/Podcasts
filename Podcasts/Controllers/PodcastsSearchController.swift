//
//  SearchController.swift
//  Podcasts
//
//  Created by Min Thet Maung on 31/12/2020.
//

import UIKit

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let podcasts = [
        Podcast(name: "Lets Build Instagram", artistName: "Brian Voong"),
        Podcast(name: "iOS Development", artistName: "Sean Allan"),
        Podcast(name: "Lets Build Instagram", artistName: "Brian Voong"),
        Podcast(name: "iOS Development", artistName: "Sean Allan"),
        Podcast(name: "Lets Build Instagram", artistName: "Brian Voong"),
        Podcast(name: "iOS Development", artistName: "Sean Allan"),
        Podcast(name: "Lets Build Instagram", artistName: "Brian Voong"),
        Podcast(name: "iOS Development", artistName: "Sean Allan"),
        Podcast(name: "Lets Build Instagram", artistName: "Brian Voong"),
        Podcast(name: "iOS Development", artistName: "Sean Allan"),
        Podcast(name: "Lets Build Instagram", artistName: "Brian Voong"),
        Podcast(name: "iOS Development", artistName: "Sean Allan"),
    ]
    
    let cellId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifeCycle Functions
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    
    
    // MARK: - Setup Functions
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    
    
    // MARK: - UITableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let podcast = podcasts[indexPath.row]
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        return cell
    }
}
