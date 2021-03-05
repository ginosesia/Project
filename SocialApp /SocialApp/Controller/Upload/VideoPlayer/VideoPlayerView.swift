//
//  VideoPlayerView.swift
//  SocialApp
//
//  Created by Gino Sesia on 04/03/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    
    let close: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(handleCloseTapped), for: .touchUpInside)
        return button
    }()
    
    let activity: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePauseTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let videoLengthRemainingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let controlsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let scrubber: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = Utilities.setThemeColor()
        slider.maximumTrackTintColor = .white
        slider.thumbTintColor = Utilities.setThemeColor()
        slider.addTarget(self, action: #selector(handleSliderChanged), for: .valueChanged)
        return slider
    }()
    
    var isPlaying = false
    
    
    
    @objc func handleCloseTapped() {
        
        print("close")
        
    }
    
    
    @objc func handleSliderChanged() {

        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(scrubber.value) * totalSeconds
                    
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (complete) in
                
            })
        }
    }
    
    
    @objc func handlePauseTapped() {
        if isPlaying {
            player?.pause()
            let image = UIImage(named: "play")
            playPauseButton.setImage(image, for: .normal)
        } else {
            player?.play()
            let image = UIImage(named: "pause")
            playPauseButton.setImage(image, for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {

        let screen = UIScreen.main.bounds
        let height = screen.height
        var frame = self.frame
        
        frame.origin.y += height
        let launcher = VideoLauncher()
        
        UIView.animate(withDuration: 0.25) {
            self.frame = frame
            launcher.dismissVideoPlayer()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
               
        setUpVideoPlayer()
        
        setGradient()
        
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))

        self.addGestureRecognizer(swipeGestureRecognizerDown)
        swipeGestureRecognizerDown.direction = .down

        
        controlsView.frame = frame
        addSubview(controlsView)
        controlsView.addSubview(playPauseButton)

        controlsView.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        controlsView.addSubview(videoLengthRemainingLabel)
        videoLengthRemainingLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        
        controlsView.addSubview(videoLengthLabel)
        videoLengthLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)

        controlsView.addSubview(scrubber)
        scrubber.anchor(top: nil, left: videoLengthRemainingLabel.rightAnchor, bottom: nil, right: videoLengthLabel.leftAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        scrubber.centerYAnchor.constraint(equalTo: videoLengthRemainingLabel.centerYAnchor).isActive = true

        controlsView.addSubview(close)
        close.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 25, height: 25)
        
        setUpContext()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Title of Video"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let views: UILabel = {
        let label = UILabel()
        label.text = "200 views"
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    let like: UILabel = {
        let label = UILabel()
        label.text = "Like"
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    let share: UILabel = {
        let label = UILabel()
        label.text = "Share"
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    func setUpContext() {
        addSubview(title)
        title.anchor(top: controlsView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)

        let stackView = UIStackView(arrangedSubviews: [views,like,share])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: title.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 0)

        let separator: UIView = {
            let sv = UIView()
            sv.backgroundColor = .gray
            return sv
        }()
        
        addSubview(separator)
        separator.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)

    }
    
    var player: AVPlayer?

    private func setUpVideoPlayer() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        if let url = NSURL(string: urlString) {
            player = AVPlayer(url: url as URL)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let stringString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds)/60)
                self.videoLengthRemainingLabel.text = "\(minutesString):\(stringString)"
                
                //move Slider
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.scrubber.value = Float(seconds / durationSeconds)
                }
            })
        }
    }
    
    
    func setGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.7,1.2]
        controlsView.layer.addSublayer(gradient)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activity.stopAnimating()
            controlsView.backgroundColor = .clear
            playPauseButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds)/60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
}
