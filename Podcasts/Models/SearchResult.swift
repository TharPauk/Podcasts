//
//  SearchResult.swift
//  Podcasts
//
//  Created by Min Thet Maung on 01/01/2021.
//

import Foundation

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
