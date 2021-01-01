//
//  SearchController.swift
//  Podcasts
//
//  Created by Min Thet Maung on 31/12/2020.
//

import UIKit
import Alamofire

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    
    // MARK: - Search Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { response in
            if let err = response.error {
                print("Error in requesting \(url) : \(err)")
            }
            
            guard let data = response.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                self.podcasts = searchResult.results
                self.tableView.reloadData()
                
            } catch let err {
                print("Error in decoding: \(err)")
            }
        }
       
    }
    
    
    // MARK: - UITableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let podcast = podcasts[indexPath.row]
        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        return cell
    }
}
