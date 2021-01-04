//
//  PlayerDetailView.swift
//  Podcasts
//
//  Created by Min Thet Maung on 02/01/2021.
//

import UIKit
import AVKit

import MediaPlayer
class PlayerDetailView: UIView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var volumeSlider: UISlider! {
        didSet {
            volumeSlider.value = AVAudioSession.sharedInstance().outputVolume
        }
    }
    
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = shrunkenTransform
        }
    }
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet { 
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    
    // MARK: - Properties
    
    var episode: Episode! {
        didSet {
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            if let urlString = episode.imageUrl?.toSecureHTTPS(),
               let url = URL(string: urlString) {
                episodeImageView.sd_setImage(with: url)
            }
            
            playEpisode()
        }
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    private let shrunkenTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    
    
    
    // MARK: - LifeCycle Functions
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPlayerCurrentTimeObserver()
        
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            self.currentTimeSlider.isEnabled = true
            self.enlargeEpisodeImageView()
        }
    }
    
    private func playEpisode() {
        guard let url = URL(string: episode.streamUrl) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    @objc private func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisideImageView()
        }
    }
    
    private func setupPlayerCurrentTimeObserver() {
        let interval = CMTime(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            self.currentTimeLabel.text = time.toString()
            let duration = self.player.currentItem?.duration
            self.durationLabel.text = duration?.toString()
            self.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationTimeSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationTimeSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    
    private func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = .identity
        }
    }
    
    private func shrinkEpisideImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = self.shrunkenTransform
        }
    }
    
    
    private func seekToTime(delta: Int64) {
        let seconds = CMTime(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }
    
    
    // MARK: - @IBAction
    
    @IBAction func handleDismiss(_ sender: Any) {

        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
        
    }
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToTime(delta: 15)
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToTime(delta: -15)
    }
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        MPVolumeView.setVolume(sender.value)
    }
    
    
}
