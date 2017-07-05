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

    var player = AVPlayer()
    var currentlyPlayedVideoName = ""

    var blenderButtons: [NSButton] = [NSButton(),
                                      NSButton(),
                                      NSButton(),
                                      NSButton(),
                                      NSButton(),
                                      NSButton(),
                                      NSButton(),
                                      NSButton(),
                                      NSButton(),
                                      NSButton()]

    var blenderButtonPos = [CGPoint(x: 484, y: 92),
                            CGPoint(x: 527, y: 98),
                            CGPoint(x: 571, y: 108),
                            CGPoint(x: 615, y: 120),
                            CGPoint(x: 662, y: 131),
                            CGPoint(x: 709, y: 143),
                            CGPoint(x: 754, y: 156),
                            CGPoint(x: 800, y: 170),
                            CGPoint(x: 840, y: 186),
                            CGPoint(x: 883, y: 204)]

    var blenderButtonSize = CGSize(width: 30, height: 30)

    var btnPlay = NSButton()
    var btnReplay = NSButton()
    var btnTurnOff = NSButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {

                // Action when the actual video is over
                switch(self.currentlyPlayedVideoName) {
                case "intro":
                    self.initBlenderButtons()
                    self.playVideo(fileNamed: "speed-0", type: "mp4")
                    self.addPlayButton()
                case "speed-10":
                    self.playVideo(fileNamed: "outro", type: "mp4")
                    self.addReplayButton()
                default:
                    //Loop the actual video, waiting for user interaction (buttonpress)
                    self.player.seek(to: kCMTimeZero)
                    self.playerView!.player?.play()
                }
            }
        })

        playVideo(fileNamed: "intro", type: "mp4")
    }

    func initBlenderButtons() {
        for i in 0...9 {
            blenderButtons[i] = NSButton(frame: NSRect(origin: blenderButtonPos[i], size: blenderButtonSize))
            blenderButtons[i].title = ""
            blenderButtons[i].tag = i + 1   // tag for which button is pressed (1-10)
            blenderButtons[i].isTransparent = true
            blenderButtons[i].sound = NSSound(named: "blender-button-pressed.m4a")
            blenderButtons[i].action = #selector(speedButtonClicked(sender:))
        }
    }

    func addBlenderButtons() {
        for i in 0...9 {
            self.playerView.contentOverlayView?.addSubview(blenderButtons[i])
        }
    }

    func removeBlenderButtons() {
        for i in 0...9 {
            blenderButtons[i].removeFromSuperview()
        }
    }

    func playVideo(fileNamed: String, type: String) {
        guard let path = Bundle.main.path(forResource: fileNamed, ofType: type) else {
            debugPrint("\(fileNamed).\(type) not found")
            return
        }

        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerView!.player = player
        playerView!.player?.play()
        currentlyPlayedVideoName = fileNamed
    }

    func speedButtonClicked(sender: NSButton) {
        playVideo(fileNamed: "speed-\(sender.tag)", type: "mp4")

        // No go back from speed-10, remove the blender and Turn Off buttons
        if sender.tag == 10 {
            self.removeBlenderButtons()
            btnTurnOff.removeFromSuperview()
        }
    }

    func addPlayButton() {
        let btnPlayImage = NSImage(named: "play-standard")
        let imageWidth = btnPlayImage?.size.width
        let imageHeight = btnPlayImage?.size.height

        btnPlay = NSButton(frame: NSRect(origin: CGPoint(x: 60, y: 165), size: CGSize(width: imageWidth!, height: imageHeight!)))
        btnPlay.image = btnPlayImage
        btnPlay.imagePosition = .imageOnly
        btnPlay.isBordered = false
        //btnPlay.sound = NSSound(named: "")
        btnPlay.action = #selector(startPlaying)

        self.playerView.contentOverlayView?.addSubview(btnPlay)

    }

    func addReplayButton() {
        let btnReplayImage = NSImage(named: "play-again-standard")
        let imageWidth = btnReplayImage?.size.width
        let imageHeight = btnReplayImage?.size.height

        btnReplay = NSButton(frame: NSRect(origin: CGPoint(x: 1200, y: 100), size: CGSize(width: imageWidth!, height: imageHeight!)))
        btnReplay.image = btnReplayImage
        btnReplay.imagePosition = .imageOnly
        btnPlay.isBordered = false
        //btnReplay.sound = NSSound(named: "")
        btnReplay.action = #selector(replayGame)

        self.playerView.contentOverlayView?.addSubview(btnReplay)
    }

    func addTurnOffButton() {
        btnTurnOff = NSButton(frame: NSRect(origin: CGPoint(x: 672, y: 198), size: CGSize(width: 65, height: 20)))
        btnTurnOff.title = ""
        btnTurnOff.rotate(byDegrees: CGFloat(-15))
        btnTurnOff.isTransparent = true
        //btnTurnOff.sound = NSSound(named: "")
        btnTurnOff.action = #selector(turnOffBlender)

        self.playerView.contentOverlayView?.addSubview(btnTurnOff)
    }

    func startPlaying() {
        addBlenderButtons()
        addTurnOffButton()
        btnPlay.removeFromSuperview()
    }

    func replayGame() {
        playVideo(fileNamed: "speed-0", type: "mp4")
        addBlenderButtons()
        addTurnOffButton()
        btnReplay.removeFromSuperview()
    }

    func turnOffBlender() {
        //TODO
    }

    override func viewDidAppear() {
        view.window?.standardWindowButton(NSWindowButton.zoomButton)?.isEnabled = false
        view.window?.styleMask.remove(NSWindowStyleMask.resizable)
    }

}
