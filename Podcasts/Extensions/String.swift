//
//  String.swift
//  Podcasts
//
//  Created by Min Thet Maung on 02/01/2021.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        self.contains("https:") ? self : self.replacingOccurrences(of: "http:", with: "https:")
    }
}
