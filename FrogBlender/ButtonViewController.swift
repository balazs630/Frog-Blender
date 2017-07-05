//
//  Button.swift
//  FrogBlender
//
//  Created by Horváth Balázs on 2017. 07. 05..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class ButtonViewController: NSViewController {

    static var blenderButtons: [NSButton] = [NSButton(),
                                             NSButton(),
                                             NSButton(),
                                             NSButton(),
                                             NSButton(),
                                             NSButton(),
                                             NSButton(),
                                             NSButton(),
                                             NSButton(),
                                             NSButton()]

    static var blenderButtonPos = [CGPoint(x: 484, y: 92),
                                   CGPoint(x: 527, y: 98),
                                   CGPoint(x: 571, y: 108),
                                   CGPoint(x: 615, y: 120),
                                   CGPoint(x: 662, y: 131),
                                   CGPoint(x: 709, y: 143),
                                   CGPoint(x: 754, y: 156),
                                   CGPoint(x: 800, y: 170),
                                   CGPoint(x: 840, y: 186),
                                   CGPoint(x: 883, y: 204)]

    static var blenderButtonSize = CGSize(width: 30, height: 30)

    static var btnPlay = NSButton()
    static var btnReplay = NSButton()
    static var btnTurnOff = NSButton()

    class func initBlenderButtons() {
        for i in 0...blenderButtons.count - 1 {
            blenderButtons[i] = NSButton(frame: NSRect(origin: blenderButtonPos[i], size: blenderButtonSize))
            blenderButtons[i].title = ""
            blenderButtons[i].tag = i + 1   // tag for which button is pressed (1-10)
            blenderButtons[i].isTransparent = true
            blenderButtons[i].action = #selector(MainViewController.speedButtonClicked(sender:))
        }
    }

    class func getBlenderButtons() -> [NSButton] {
        return blenderButtons
    }

    class func removeBlenderButtons() {
        for i in 0...blenderButtons.count - 1 {
            blenderButtons[i].removeFromSuperview()
        }
    }

    class func addPlayButton() -> NSButton {
        if let btnPlayImage = NSImage(named: "play-standard") {
            let imageWidth = btnPlayImage.size.width
            let imageHeight = btnPlayImage.size.height

            btnPlay = NSButton(frame: NSRect(origin: CGPoint(x: 60, y: 165), size: CGSize(width: imageWidth, height: imageHeight)))
            btnPlay.image = btnPlayImage
            btnPlay.imagePosition = .imageOnly
            btnPlay.isBordered = false
            btnPlay.action = #selector(MainViewController.startPlaying)
        }
        return btnPlay
    }

    class func addReplayButton() -> NSButton {
        if let btnReplayImage = NSImage(named: "play-again-standard") {
            let imageWidth = btnReplayImage.size.width
            let imageHeight = btnReplayImage.size.height

            btnReplay = NSButton(frame: NSRect(origin: CGPoint(x: 1200, y: 100), size: CGSize(width: imageWidth, height: imageHeight)))
            btnReplay.image = btnReplayImage
            btnReplay.imagePosition = .imageOnly
            btnReplay.isBordered = false
            btnReplay.action = #selector(MainViewController.replayGame)
        }
        return btnReplay
    }

    class func addTurnOffButton() -> NSButton {
        btnTurnOff = NSButton(frame: NSRect(origin: CGPoint(x: 672, y: 198), size: CGSize(width: 65, height: 20)))
        btnTurnOff.title = ""
        btnTurnOff.rotate(byDegrees: CGFloat(-15))
        btnTurnOff.isTransparent = true
        btnTurnOff.action = #selector(MainViewController.turnOffBlender)

        return btnTurnOff
    }

}
