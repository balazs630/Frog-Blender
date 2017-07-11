//
//  MainViewController.swift
//  FrogBlender
//
//  Created by Horváth Balázs on 2017. 07. 01..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class MainViewController: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!

    var videoPlayer = AVPlayer()
    var audioPlayer = AVAudioPlayer()
    var currentlyPlayedVideoName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.videoPlayer.currentItem,
                                               queue: nil,
                                               using: { (_) in
            DispatchQueue.main.async {

                // Action when the actual video is over
                switch(self.currentlyPlayedVideoName) {
                case "intro":
                    ButtonViewController.initBlenderButtons(to: self)
                    self.playVideo(fileNamed: "speed-0", type: "mp4")
                    self.playerView!.player?.pause()
                    self.playerView.contentOverlayView?.addSubview(ButtonViewController.addPlayButton(to: self))
                case "speed-10":
                    self.playVideo(fileNamed: "outro", type: "mp4")
                    self.playerView.contentOverlayView?.addSubview(ButtonViewController.addReplayButton(to: self))
                    self.playSound(fileNamed: "replay-button-appears", type: "aac")
                default:
                    //Loop the actual video, waiting for user interaction (button press)
                    self.videoPlayer.seek(to: kCMTimeZero)
                    self.playerView!.player?.play()
                }
            }
        })

        playVideo(fileNamed: "intro", type: "mp4")
    }

    override func viewDidAppear() {
        view.window?.standardWindowButton(NSWindowButton.zoomButton)?.isEnabled = false
        view.window?.styleMask.remove(NSWindowStyleMask.resizable)
    }

    func playVideo(fileNamed: String, type: String) {
        guard let path = Bundle.main.path(forResource: fileNamed, ofType: type) else {
            debugPrint("\(fileNamed).\(type) not found")
            return
        }

        videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        playerView!.player = videoPlayer
        playerView!.player?.play()
        currentlyPlayedVideoName = fileNamed
    }

    func playSound(fileNamed: String, type: String) {
        guard let path = Bundle.main.path(forResource: fileNamed, ofType: type) else {
            debugPrint("\(fileNamed).\(type) not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.play()
        } catch {
            print(error)
        }
    }

    func speedButtonClicked(sender: NSButton) {
        playSound(fileNamed: "blender-button-pressed", type: "aac")
        playVideo(fileNamed: "speed-\(sender.tag)", type: "mp4")

        // No go back from speed-10, remove the blender and Turn Off buttons
        if sender.tag == 10 {
            ButtonViewController.removeBlenderButtons()
            ButtonViewController.btnTurnOff.removeFromSuperview()
        }
    }

    func startPlaying() {
        playVideo(fileNamed: "speed-0", type: "mp4")

        for button in ButtonViewController.blenderButtons {
            playerView.contentOverlayView?.addSubview(button)
        }

        playerView.contentOverlayView?.addSubview(ButtonViewController.addTurnOffButton())
        ButtonViewController.btnPlay.removeFromSuperview()
    }

    func replayGame() {
        playSound(fileNamed: "replay-button-pressed", type: "aac")
        playVideo(fileNamed: "speed-0", type: "mp4")
        self.playerView!.player?.pause()
        self.playerView.contentOverlayView?.addSubview(ButtonViewController.addPlayButton(to: self))

        ButtonViewController.btnReplay.removeFromSuperview()
    }

    func turnOffBlender() {
        playSound(fileNamed: "blender-button-pressed", type: "aac")
        playVideo(fileNamed: "speed-0", type: "mp4")
        self.playerView!.player?.pause()

        ButtonViewController.removeBlenderButtons()
        ButtonViewController.btnTurnOff.removeFromSuperview()
        self.playerView.contentOverlayView?.addSubview(ButtonViewController.addPlayButton(to: self))
    }

    override func mouseEntered(with event: NSEvent) {
        // Identify which button triggered the mouseEntered event

        if let buttonName = event.trackingArea?.userInfo?.values.first as? String {
            switch (buttonName) {
            case "btnPlay":
                ButtonViewController.btnPlay.image = NSImage(named: "play-hover")
                playSound(fileNamed: "play-button-hover", type: "aac")
            case "btnReplay":
                ButtonViewController.btnReplay.image = NSImage(named: "replay-hover")
                playSound(fileNamed: "replay-button-hover", type: "aac")
            case "btnBlender":
                playSound(fileNamed: "blender-button-hover", type: "aac")
            default:
                print("The given button name: \"\(buttonName)\" is unknown!")
            }
        }
    }

    override func mouseExited(with event: NSEvent) {
        // Identify which button triggered the mouseEntered event

        if let buttonName = event.trackingArea?.userInfo?.values.first as? String {
            switch (buttonName) {
            case "btnPlay":
                ButtonViewController.btnPlay.image = NSImage(named: "play-standard")
            case "btnReplay":
                ButtonViewController.btnReplay.image = NSImage(named: "replay-standard")
            case "btnBlender":
                break
            default:
                print("The given button name: \"\(buttonName)\" is unknown!")
            }
        }
    }

}
