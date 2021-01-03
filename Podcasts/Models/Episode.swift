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
    let author: String
    var imageUrl: String?
    let streamUrl: String
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pudDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
    
}
