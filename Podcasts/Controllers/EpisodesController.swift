//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Min Thet Maung on 01/01/2021.
//

import UIKit

class EpisodesController: UITableViewController {
    
    private let cellId = "cellId"
    var episodes = [Episode]()
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    
    // MARK: - Fetch Data
    
    private func fetchEpisodes() {
        guard let podcast = self.podcast else { return }
        
        APIService.shared.fetchEpisodes(podcast: podcast) { (episodes) in
            DispatchQueue.main.async {
                self.episodes = episodes
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Setup Functions
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let keyWindow = UIApplication.shared.keyWindow
        let playerDetailView = Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
        
        playerDetailView.episode = episodes[indexPath.row]
        playerDetailView.frame = view.frame
        
        keyWindow?.addSubview(playerDetailView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        132
    }
    
}
