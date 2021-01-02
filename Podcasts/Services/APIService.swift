//
//  APIService.swift
//  Podcasts
//
//  Created by Min Thet Maung on 01/01/2021.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    static let shared = APIService()
    private let iTunesAPI = "https://itunes.apple.com/search"
    
    func searchPodcast(searchText: String, completion: @escaping ([Podcast]) -> ()) {
        let parameters = ["term": searchText, "media": "podcast"]
        
        AF.request(iTunesAPI, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { response in
            if let err = response.error {
                print("Error in requesting \(self.iTunesAPI) : \(err)")
            }
            
            guard let data = response.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completion(searchResult.results)
            } catch let err {
                print("Error in decoding: \(err)")
                completion([])
            }
        }
       
    }
    
    
    func fetchEpisodes(podcast: Podcast, completion: @escaping ([Episode]) -> ()) {
        guard let feedUrl = podcast.feedUrl else { return }
        
        let secureUrl = feedUrl.contains("https:") ? feedUrl : feedUrl.replacingOccurrences(of: "http:", with: "https:")
        
        guard let url = URL(string: secureUrl) else { return }
        
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            
            switch result {
            case .success(let feed):
                var episodes = [Episode]()
                feed.rssFeed?.items?.forEach {
                    let episode = Episode(feedItem: $0)
                    episodes.append(episode)
                }
                completion(episodes)
                
            case .failure(let err):
                completion([])
                print("Fail to fetch episodes: \(err.localizedDescription)")
            }
        }
    }
}
