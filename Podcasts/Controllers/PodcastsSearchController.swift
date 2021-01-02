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
        // This removes horizontal lines when table view is empty
        tableView.tableFooterView = UIView()
        
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemPurple
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "No results found.\nPlease enter keyword to search."
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.count > 0 ? 0 : 200
    }
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = podcasts[indexPath.row]
        navigationController?.pushViewController(episodesController, animated: true)
    }
}
