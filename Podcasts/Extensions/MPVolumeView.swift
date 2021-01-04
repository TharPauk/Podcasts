//
//  MPVolumeView.swift
//  Podcasts
//
//  Created by Min Thet Maung on 04/01/2021.
//

import MediaPlayer

extension MPVolumeView {
    
    static let volumeSlider: UISlider? = {
        let volumeView = MPVolumeView(frame: .zero)
        return volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
    }()
    
    static var volume: Float {
        get {
            return volumeSlider?.value ?? AVAudioSession.sharedInstance().outputVolume
        }
        set {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
                volumeSlider?.value = newValue
            }
        }
    }

}
