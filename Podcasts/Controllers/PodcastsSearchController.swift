//
//  SearchController.swift
//  Podcasts
//
//  Created by Min Thet Maung on 31/12/2020.
//

import UIKit

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    private var podcasts = [Podcast]()
    private let cellId = "cellId"
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    
    
    // MARK: - Search Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.searchPodcast(searchText: searchText) { (podcasts) in
            DispatchQueue.main.async {
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - UITableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        cell.podcast = self.podcasts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        132
    }
}
