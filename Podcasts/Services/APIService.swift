//
//  APIService.swift
//  Podcasts
//
//  Created by Min Thet Maung on 01/01/2021.
//

import Foundation
import Alamofire

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
}
