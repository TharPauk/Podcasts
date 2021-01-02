//
//  Podcast.swift
//  Podcasts
//
//  Created by Min Thet Maung on 01/01/2021.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel : UILabel!
    
    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            guard let urlString = podcast.artworkUrl600,
                  let url = URL(string: urlString)
            else { return }
            
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
}
