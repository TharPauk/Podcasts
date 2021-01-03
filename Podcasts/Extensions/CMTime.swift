//
//  CMTime.swift
//  Podcasts
//
//  Created by Min Thet Maung on 03/01/2021.
//


import Foundation
import AVKit

extension CMTime {
    
    func toString() -> String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        
        return String(format: "%0d:%02d", minutes, seconds)
    }
    
}
