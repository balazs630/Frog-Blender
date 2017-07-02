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
    var btnReplay = NSButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {

                // Action when the actual video is over
                switch(self.currentlyPlayedVideoName) {
                case "intro":
                    self.playVideo(fileNamed: "speed-0", type: "mp4")
                case "speed-10":
                    self.playVideo(fileNamed: "outro", type: "mp4")
                    self.gameOver()
                default:
                    //Loop the actual video, waiting for user interaction..
                    self.player.seek(to: kCMTimeZero)
                    self.playerView!.player?.play()
                }
            }
        })

        playVideo(fileNamed: "intro", type: "mp4")
    }

    func initButtons() {
        for i in 0...9 {
            blenderButtons[i] = NSButton(frame: NSRect(origin: blenderButtonPos[i], size: blenderButtonSize))
            blenderButtons[i].title = ""
            blenderButtons[i].tag = i + 1   // tag for which button is pressed (1-10)
            blenderButtons[i].isTransparent = true
            blenderButtons[i].sound = NSSound(named: "blender-button-pressed.m4a")
            blenderButtons[i].action = #selector(speedButtonClicked(sender:))

            self.view.addSubview(blenderButtons[i])
            self.playerView.contentOverlayView?.addSubview(blenderButtons[i])
        }
    }

    func playVideo(fileNamed: String, type: String) {
        guard let path = Bundle.main.path(forResource: fileNamed, ofType: type) else {
            debugPrint("\(fileNamed).\(type) not found")
            return
        }

        initButtons()

        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerView!.player = player
        playerView!.player?.play()
        currentlyPlayedVideoName = fileNamed
    }

    func speedButtonClicked(sender: NSButton) {
        playVideo(fileNamed: "speed-\(sender.tag)", type: "mp4")
    }

    func gameOver() {
        let btnReplayImage = NSImage(named: "replay")
        let imageWidth = btnReplayImage?.size.width
        let imageHeight = btnReplayImage?.size.height

        btnReplay = NSButton(frame: NSRect(origin: CGPoint(x: 800, y: 600), size: CGSize(width: imageWidth!, height: imageHeight!)))
        btnReplay.image = NSImage(named: "replay")
        btnReplay.bezelStyle = .rounded
        btnReplay.sound = NSSound(named: "blender-mixing.m4a")
        btnReplay.action = #selector(replayGame)

        self.view.addSubview(btnReplay)
        self.playerView.contentOverlayView?.addSubview(btnReplay)
    }

    func replayGame() {
        playVideo(fileNamed: "speed-0", type: "mp4")
        btnReplay.removeFromSuperview()
    }

    override func viewDidAppear() {
        view.window?.standardWindowButton(NSWindowButton.zoomButton)?.isEnabled = false
        view.window?.styleMask.remove(NSWindowStyleMask.resizable)
    }

}
