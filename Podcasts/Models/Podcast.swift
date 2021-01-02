//
//  Podcast.swift
//  Podcasts
//
//  Created by Min Thet Maung on 31/12/2020.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var trackCount: Int?
    var artworkUrl600: String?
    var feedUrl: String?
}
