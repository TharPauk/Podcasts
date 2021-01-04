//
//  CMTime.swift
//  Podcasts
//
//  Created by Min Thet Maung on 03/01/2021.
//


import AVKit

extension CMTime {
    
    func toString() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
