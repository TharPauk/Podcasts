//
//  PlayerDetailView.swift
//  Podcasts
//
//  Created by Min Thet Maung on 02/01/2021.
//

import UIKit
import AVKit

class PlayerDetailView: UIView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet { 
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    // MARK: - Properties
    
    var episode: Episode! {
        didSet {
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            if let urlString = episode.imageUrl?.toSecureHTTPS(),
               let url = URL(string: urlString) {
                episodeImageView.sd_setImage(with: url)
            }
            
            playEpisode()
        }
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    private func playEpisode() {
        guard let url = URL(string: episode.streamUrl) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    @objc private func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            return
        }
        player.pause()
        playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
    }
    
    
    
    // MARK: - @IBAction
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
}
