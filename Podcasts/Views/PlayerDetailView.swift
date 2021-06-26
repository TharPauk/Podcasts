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
    
    
    @IBOutlet weak var maximizedView: UIStackView!
    @IBOutlet weak var minimizedView: UIView!
    
    
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
            miniPlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    @IBOutlet weak var miniFastForwardButton: UIButton! {
        didSet {
            miniFastForwardButton.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
            miniFastForwardButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    
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
            miniTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            if let urlString = episode.imageUrl?.toSecureHTTPS(),
               let url = URL(string: urlString) {
                episodeImageView.sd_setImage(with: url)
                miniEpisodeImageView.sd_setImage(with: url)
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
    
    var panGesture: UIPanGestureRecognizer!
    
    // MARK: - LifeCycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        setupPlayerStartTimeObserver()
        setupPlayerCurrentTimeObserver()
        
        MPVolumeView.volumeSlider?.addTarget(self, action: #selector(onMPVolumeSliderChange(sender:)), for: .valueChanged)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
       
        switch gesture.state {
        case .changed: handlePanChanged(gesture: gesture)
        case .ended: handlePanEnded(gesture: gesture)
        default: break
        }
        
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let y = gesture.translation(in: self.superview).y
        
        transform = CGAffineTransform(translationX: 0, y: y)
        minimizedView.alpha = 1 + y / 200
        maximizedView.alpha = -y / 200
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let y = gesture.translation(in: self.superview).y
        let velocityY = gesture.velocity(in: self.superview).y
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            if y < -200 || velocityY < -500 {
                let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                mainTabBarController?.maximizePlayerDetailView(episode: nil)
                gesture.isEnabled = false
            } else {
                self.minimizedView.alpha = 1
                self.maximizedView.alpha = 0
            }
        })
    }
    
    @objc func handleTapMaximize() {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetailView(episode: nil)
        panGesture.isEnabled = false
    }
    
    static func initFromNib() -> PlayerDetailView {
        return Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
    }
    
    @objc private func onMPVolumeSliderChange(sender: UISlider) {
        volumeSlider.value = sender.value
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
    
    
    
    // MARK: - Player related Functions
    
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
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisideImageView()
        }
    }
    
    
    private func setupPlayerStartTimeObserver() {
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.currentTimeSlider.isEnabled = true
            self?.enlargeEpisodeImageView()
        }
    }
    
    private func setupPlayerCurrentTimeObserver() {
        let interval = CMTime(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toString()
            let duration = self?.player.currentItem?.duration
            self?.durationLabel.text = duration?.toString()
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationTimeSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationTimeSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    
    private func seekToTime(delta: Int64) {
        let seconds = CMTime(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }
    
    
    
    // MARK: - @IBAction
    
    @IBAction func handleDismiss(_ sender: Any) {
        let mainTabBarController =  UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetailView()
        panGesture.isEnabled = true
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
        MPVolumeView.volume = sender.value
    }
    
    deinit {
        print("PlayerDetailView deinit.")
    }
}
