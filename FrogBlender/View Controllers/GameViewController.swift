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
    var observer: Any?

    // MARK: Outlets
    @IBOutlet weak var playerView: AVPlayerView!

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        observer = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.videoPlayer.currentItem,
                                               queue: nil,
                                               using: { (_) in
            DispatchQueue.main.async {
                // Action when the actual video is over
                switch self.currentlyPlayedVideoName {
                case .intro:
                    ButtonView.initBlenderButtons(to: self)
                    self.playVideo(fileNamed: .speed0)
                    self.playerView!.player?.pause()
                    self.playerView.contentOverlayView?.addSubview(ButtonView.addPlayButton(to: self))
                case .speed10:
                    self.playVideo(fileNamed: .outro)
                    self.playerView.contentOverlayView?.addSubview(ButtonView.addReplayButton(to: self))
                    self.playSound(fileNamed: .replayButtonAppears)
                default:
                    // Loop the actual video, waiting for user interaction (button press)
                    self.videoPlayer.seek(to: kCMTimeZero)
                    self.playerView!.player?.play()
                }
            }
        })

        playVideo(fileNamed: .intro)
    }

    override func viewDidAppear() {
        view.window?.standardWindowButton(.zoomButton)?.isEnabled = false
        view.window?.styleMask.remove(.resizable)
    }

    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }
}

// MARK: - AVPlayer Utility methods
extension GameViewController {
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
            ButtonView.removeBlenderButtons()
            ButtonView.btnTurnOff.removeFromSuperview()
        }
    }

    @objc func startPlaying() {
        playVideo(fileNamed: .speed0)

        for button in ButtonView.blenderButtons {
            playerView.contentOverlayView?.addSubview(button)
        }

        playerView.contentOverlayView?.addSubview(ButtonView.addTurnOffButton())
        ButtonView.btnPlay.removeFromSuperview()
    }

    @objc func replayGame() {
        playSound(fileNamed: .replayButtonPressed)
        playVideo(fileNamed: .speed0)
        self.playerView!.player?.pause()
        self.playerView.contentOverlayView?.addSubview(ButtonView.addPlayButton(to: self))

        ButtonView.btnReplay.removeFromSuperview()
    }

    @objc func turnOffBlender() {
        playSound(fileNamed: .blenderSpeedGearButtonPressed)
        playVideo(fileNamed: .speed0)
        self.playerView!.player?.pause()

        ButtonView.removeBlenderButtons()
        ButtonView.btnTurnOff.removeFromSuperview()
        self.playerView.contentOverlayView?.addSubview(ButtonView.addPlayButton(to: self))
    }
}

// MARK: - Button mouseover events
extension GameViewController {
    override func mouseEntered(with event: NSEvent) {
        if let buttonName = event.trackingArea?.userInfo?.values.first as? ButtonType {
            switch buttonName {
            case .btnPlay:
                ButtonView.btnPlay.image = NSImage(named: .playHover)
                playSound(fileNamed: .playButtonHover)
            case .btnReplay:
                ButtonView.btnReplay.image = NSImage(named: .replayHover)
                playSound(fileNamed: .replayButtonHover)
            case .btnSpeedGear:
                playSound(fileNamed: .blenderSpeedGearButtonHover)
            }
        }
    }

    override func mouseExited(with event: NSEvent) {
        if let buttonName = event.trackingArea?.userInfo?.values.first as? ButtonType {
            switch buttonName {
            case .btnPlay:
                ButtonView.btnPlay.image = NSImage(named: .playStandard)
            case .btnReplay:
                ButtonView.btnReplay.image = NSImage(named: .replayStandard)
            case .btnSpeedGear:
                break
            }
        }
    }
}
