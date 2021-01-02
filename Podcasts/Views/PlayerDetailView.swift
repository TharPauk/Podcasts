//
//  PlayerDetailView.swift
//  Podcasts
//
//  Created by Min Thet Maung on 02/01/2021.
//

import UIKit

class PlayerDetailView: UIView {
    
    
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    var episode: Episode! {
        didSet {
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            if let urlString = episode.imageUrl?.toSecureHTTPS(),
               let url = URL(string: urlString) {
                episodeImageView.sd_setImage(with: url)
            }
        }
    }
    
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
}
