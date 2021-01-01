//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Min Thet Maung on 01/01/2021.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    private let cellId = "cellId"
    var episodes = [Episode]()
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    
    private func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        
        let secureUrl = feedUrl.contains("https:") ? feedUrl : feedUrl.replacingOccurrences(of: "http:", with: "https:")
        
        guard let url = URL(string: secureUrl) else { return }
        
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            
            switch result {
            case .success(let feed):
                feed.rssFeed?.items?.forEach {
                    let episode = Episode()
                    episode.title = $0.title
                    self.episodes.append(episode)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let err):
                print("Fail to fetch episodes: \(err.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Setup Functions
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    
    
    // MARK: - UITableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = episodes[indexPath.row].title
        return cell
    }
    
    
}
