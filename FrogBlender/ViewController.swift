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

class ViewController: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!

    var player = AVPlayer()
    var currentlyPlayedVideoName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player.seek(to: kCMTimeZero)

                // Action when the actual video is over
                switch(self.currentlyPlayedVideoName) {
                case "intro":
                    self.playVideo(fileNamed: "speed-0", type: "mp4")
                case "speed-9":
                    self.gameOver()
                default:
                    //Loop the actual video, waiting for user interaction..
                    self.playerView!.player?.play()
                }
            }
        })

        playVideo(fileNamed: "intro", type: "mp4")

    }

    private func playVideo(fileNamed: String, type: String) {
        guard let path = Bundle.main.path(forResource: fileNamed, ofType: type) else {
            debugPrint("\(fileNamed).\(type) not found")
            return
        }

        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerView!.player = player
        playerView!.player?.play()
        currentlyPlayedVideoName = fileNamed
    }

    func gameOver() {
        print("GameOver!")
    }

    override func viewDidAppear() {
        // Disable green zoom button
        view.window?.standardWindowButton(NSWindowButton.zoomButton)?.isEnabled = false
    }

}
