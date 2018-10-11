//
//  GameViewController.swift
//  FrogBlender
//
//  Created by Horváth Balázs on 2017. 07. 01..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import AVKit

class GameViewController: NSViewController {
    // MARK: Properties
    var videoPlayer = AVPlayer()
    var audioPlayer = AVAudioPlayer()
    var currentlyPlayedVideoName = VideoAssetIdentifier.intro
    var videoPlaybackObserver: Any?

    var speedButtons = Array(repeating: NSButton(), count: Constant.speedButtonCount)
    var playButton = NSButton()
    var replayButton = NSButton()
    var turnOffButton = NSButton()

    // MARK: Outlets
    @IBOutlet weak var playerView: AVPlayerView!

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSelf()
        makeButtons()
        observeVideoDidPlayToEndTime()
        playVideo(fileNamed: .intro)
    }

    deinit {
        if let observer = videoPlaybackObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

// MARK: - Screen configuration
extension GameViewController {
    private func configureSelf() {
        view.window?.standardWindowButton(.zoomButton)?.isEnabled = false
        view.window?.styleMask.remove(.resizable)
    }

    private func makeButtons() {
        speedButtons = ButtonFactory.makeSpeedButtons(for: self)
        playButton = ButtonFactory.makePlayButton(for: self)
        replayButton = ButtonFactory.makeReplayButton(for: self)
        turnOffButton = ButtonFactory.makeTurnOffButton()
    }
}

// MARK: - AVPlayer Utility methods
extension GameViewController {
    private func observeVideoDidPlayToEndTime() {
        videoPlaybackObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                       object: self.videoPlayer.currentItem,
                                                                       queue: nil,
                                                                       using: { (_) in
            DispatchQueue.main.async {
            // Action when the actual video is over
                switch self.currentlyPlayedVideoName {
                case .intro:
                    self.playVideo(fileNamed: .speed0)
                    self.playerView!.player?.pause()
                    self.playerView.contentOverlayView?.addSubview(self.playButton)
                case .speed10:
                    self.playVideo(fileNamed: .outro)
                    self.playerView.contentOverlayView?.addSubview(self.replayButton)
                    self.playSound(fileNamed: .replayButtonAppears)
                default:
                    // Loop the actual video, waiting for user interaction (button press)
                    self.videoPlayer.seek(to: CMTime.zero)
                    self.playerView!.player?.play()
                }
            }
        })
    }

    private func playVideo(fileNamed: VideoAssetIdentifier, type: FileType = .mp4) {
        guard let path = Bundle.main.path(forResource: fileNamed.rawValue, ofType: type.rawValue) else {
            debugPrint("\(fileNamed).\(type) not found")
            return
        }

        videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        playerView!.player = videoPlayer
        playerView!.player?.play()
        currentlyPlayedVideoName = fileNamed
    }

    private func playSound(fileNamed: SoundAssetIdentifier, type: FileType = .aac) {
        guard let path = Bundle.main.path(forResource: fileNamed.rawValue, ofType: type.rawValue) else {
            debugPrint("\(fileNamed).\(type) not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.play()
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}

// MARK: - Button click actions
extension GameViewController {
    @objc func speedButtonClicked(sender: NSButton) {
        let buttonName = "speed-\(sender.tag)"
        guard let blenderSpeedGear = VideoAssetIdentifier(rawValue: buttonName) else {
            debugPrint("\(buttonName) button not found")
            return
        }

        playSound(fileNamed: .blenderSpeedGearButtonPressed)
        playVideo(fileNamed: blenderSpeedGear)

        // No go back from speed-10, remove the blender speed gear and Turn off buttons
        if sender.tag == 10 {
            speedButtons.removeFromSuperview()
            turnOffButton.removeFromSuperview()
        }
    }

    @objc func startPlaying() {
        playVideo(fileNamed: .speed0)

        speedButtons.forEach {
            playerView.contentOverlayView?.addSubview($0)
        }

        playerView.contentOverlayView?.addSubview(turnOffButton)

        playButton.image = NSImage(named: .playStandard)
        playButton.removeFromSuperview()
    }

    @objc func replayGame() {
        playSound(fileNamed: .replayButtonPressed)
        playVideo(fileNamed: .speed0)
        self.playerView!.player?.pause()
        self.playerView.contentOverlayView?.addSubview(playButton)

        replayButton.image = NSImage(named: .replayStandard)
        replayButton.removeFromSuperview()
    }

    @objc func turnOffBlender() {
        playSound(fileNamed: .blenderSpeedGearButtonPressed)
        playVideo(fileNamed: .speed0)
        self.playerView!.player?.pause()

        speedButtons.removeFromSuperview()
        turnOffButton.removeFromSuperview()
        self.playerView.contentOverlayView?.addSubview(playButton)
    }
}

// MARK: - Button mouseover events
extension GameViewController {
    override func mouseEntered(with event: NSEvent) {
        if let buttonType = event.trackingArea?.userInfo?.values.first as? ControlButtonType {
            switch buttonType {
            case .btnPlay:
                playButton.image = NSImage(named: .playHover)
                playSound(fileNamed: .playButtonHover)
            case .btnReplay:
                replayButton.image = NSImage(named: .replayHover)
                playSound(fileNamed: .replayButtonHover)
            case .btnSpeedGear:
                playSound(fileNamed: .blenderSpeedGearButtonHover)
            }
        }
    }

    override func mouseExited(with event: NSEvent) {
        if let buttonType = event.trackingArea?.userInfo?.values.first as? ControlButtonType {
            switch buttonType {
            case .btnPlay:
                playButton.image = NSImage(named: .playStandard)
            case .btnReplay:
                replayButton.image = NSImage(named: .replayStandard)
            case .btnSpeedGear:
                break
            }
        }
    }
}
