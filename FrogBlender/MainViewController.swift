//
//  ViewController.swift
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

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {

                // Action when the actual video is over
                switch(self.currentlyPlayedVideoName) {
                case "intro":
                    ButtonViewController.initBlenderButtons()
                    self.playVideo(fileNamed: "speed-0", type: "mp4")
                    self.playerView.contentOverlayView?.addSubview(ButtonViewController.addPlayButton())
                case "speed-10":
                    self.playVideo(fileNamed: "outro", type: "mp4")
                    self.playerView.contentOverlayView?.addSubview(ButtonViewController.addReplayButton())
                    self.playSound(fileNamed: "replay-button-appears", type: "aac")
                default:
                    //Loop the actual video, waiting for user interaction (buttonpress)
                    self.videoPlayer.seek(to: kCMTimeZero)
                    self.playerView!.player?.play()
                }
            }
        })

        playVideo(fileNamed: "intro", type: "mp4")
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
        playSound(fileNamed: "play-button-hover", type: "aac")

        for button in ButtonViewController.getBlenderButtons() {
            playerView.contentOverlayView?.addSubview(button)
        }

        playerView.contentOverlayView?.addSubview(ButtonViewController.addTurnOffButton())
        ButtonViewController.btnPlay.removeFromSuperview()
    }

    func replayGame() {
        playSound(fileNamed: "replay-button-pressed", type: "aac")
        playVideo(fileNamed: "speed-0", type: "mp4")

        for button in ButtonViewController.getBlenderButtons() {
            playerView.contentOverlayView?.addSubview(button)
        }

        playerView.contentOverlayView?.addSubview(ButtonViewController.addTurnOffButton())
        ButtonViewController.btnReplay.removeFromSuperview()
    }

    func turnOffBlender() {
        playSound(fileNamed: "blender-button-pressed", type: "aac")
        //TODO
    }

    override func viewDidAppear() {
        view.window?.standardWindowButton(NSWindowButton.zoomButton)?.isEnabled = false
        view.window?.styleMask.remove(NSWindowStyleMask.resizable)
    }

}
