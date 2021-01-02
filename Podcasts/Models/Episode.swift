//
//  Episode.swift
//  Podcasts
//
//  Created by Min Thet Maung on 01/01/2021.
//

import Foundation
import FeedKit

struct Episode: Codable {
    let title: String
    let pudDate: Date
    let description: String
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pudDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
    }
    
}
