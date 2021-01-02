//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Min Thet Maung on 02/01/2021.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    
    var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            pubDateLabel.text = changeDateFormat(date: episode.pudDate)
            
            if let imageUrl = episode.imageUrl,
               let url = URL(string: imageUrl.toSecureHTTPS()) {
                episodeImageView.sd_setImage(with: url)
            }
        }
    }
    
    private func changeDateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    
}
