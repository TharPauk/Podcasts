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
        guard let feedUrl = podcast.feedUrl,
              let url = URL(string: feedUrl.toSecureHTTPS())
        else { return }
        
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            
            switch result {
            case .success(let feed):
                completion(self.convertFeedToEpisode(feed: feed))
                
            case .failure(let err):
                completion([])
                print("Fail to fetch episodes: \(err.localizedDescription)")
            }
        }
    }
    
    
    
    // MARK: - Helper Functions
    
    private func convertFeedToEpisode(feed: Feed) -> [Episode] {
        var episodes = [Episode]()
        let podcastImageUrl = feed.rssFeed?.iTunes?.iTunesImage?.attributes?.href
        
        feed.rssFeed?.items?.forEach {
            var episode = Episode(feedItem: $0)
            
            // check if each episode has an image, if not use podcast image for an episode image
            if episode.imageUrl == nil {
                episode.imageUrl = podcastImageUrl
            }
            episodes.append(episode)
        }
        return episodes
    }
}
