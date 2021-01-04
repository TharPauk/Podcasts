//
//  MPVolumeView.swift
//  Podcasts
//
//  Created by Min Thet Maung on 04/01/2021.
//

import MediaPlayer

extension MPVolumeView {
    static func setVolume(_ volume: Float) {

        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            volumeView.isHidden = true
            volumeView.showsVolumeSlider = false
            slider?.value = volume
        }

    }
}
