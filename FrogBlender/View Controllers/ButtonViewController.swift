//
//  ButtonViewController.swift
//  FrogBlender
//
//  Created by Horváth Balázs on 2017. 07. 05..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class ButtonViewController: NSViewController {
    
    static var blenderButtons: [NSButton] = Array(repeating: NSButton(), count: 10)

    static var blenderButtonsPos = [CGPoint(x: 309, y: 57),
                                   CGPoint(x: 336, y: 61),
                                   CGPoint(x: 364, y: 67),
                                   CGPoint(x: 392, y: 75),
                                   CGPoint(x: 422, y: 83),
                                   CGPoint(x: 452, y: 90),
                                   CGPoint(x: 481, y: 98),
                                   CGPoint(x: 510, y: 107),
                                   CGPoint(x: 536, y: 117),
                                   CGPoint(x: 563, y: 129)]

    static var blenderButtonSize = CGSize(width: 20, height: 20)

    static var btnPlay = NSButton()
    static var btnReplay = NSButton()
    static var btnTurnOff = NSButton()

    class func initBlenderButtons(to view: NSViewController) {
        for i in 0...blenderButtons.count - 1 {
            blenderButtons[i] = NSButton(frame: NSRect(origin: blenderButtonsPos[i],
                                                       size: blenderButtonSize))
            blenderButtons[i].title = ""
            blenderButtons[i].tag = i + 1   // tag for which blender speed button was pressed (1-10)
            blenderButtons[i].isTransparent = true
            blenderButtons[i].action = #selector(MainViewController.speedButtonClicked(sender:))
            let area = NSTrackingArea.init(rect: blenderButtons[i].bounds,
                                           options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways],
                                           owner: view,
                                           userInfo: ["btnName": "btnBlender"])
            blenderButtons[i].addTrackingArea(area)
        }
    }

    class func removeBlenderButtons() {
        for i in 0...blenderButtons.count - 1 {
            blenderButtons[i].removeFromSuperview()
        }
    }

    class func addPlayButton(to view: NSViewController) -> NSButton {
        if let btnPlayImage = NSImage(named: NSImage.Name(rawValue: "play-standard")) {
            let imageWidth = btnPlayImage.size.width
            let imageHeight = btnPlayImage.size.height

            btnPlay = NSButton(frame: NSRect(origin: CGPoint(x: 29, y: 98),
                                             size: CGSize(width: imageWidth, height: imageHeight)))
            btnPlay.image = btnPlayImage
            btnPlay.imagePosition = .imageOnly
            btnPlay.isBordered = false
            btnPlay.action = #selector(MainViewController.startPlaying)
            let area = NSTrackingArea.init(rect: btnPlay.bounds,
                                           options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways],
                                           owner: view,
                                           userInfo: ["btnName": "btnPlay"])
            btnPlay.addTrackingArea(area)
        }
        return btnPlay
    }

    class func addReplayButton(to view: NSViewController) -> NSButton {
        if let btnReplayImage = NSImage(named: NSImage.Name(rawValue: "replay-standard")) {
            let imageWidth = btnReplayImage.size.width
            let imageHeight = btnReplayImage.size.height

            btnReplay = NSButton(frame: NSRect(origin: CGPoint(x: 756, y: 23),
                                               size: CGSize(width: imageWidth, height: imageHeight)))
            btnReplay.image = btnReplayImage
            btnReplay.imagePosition = .imageOnly
            btnReplay.isBordered = false
            btnReplay.action = #selector(MainViewController.replayGame)
            let area = NSTrackingArea.init(rect: btnReplay.bounds,
                                           options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways],
                                           owner: view,
                                           userInfo: ["btnName": "btnReplay"])
            btnReplay.addTrackingArea(area)
        }
        return btnReplay
    }

    class func addTurnOffButton() -> NSButton {
        btnTurnOff = NSButton(frame: NSRect(origin: CGPoint(x: 423, y: 124),
                                            size: CGSize(width: 50, height: 15)))
        btnTurnOff.title = ""
        btnTurnOff.rotate(byDegrees: CGFloat(-15))
        btnTurnOff.isTransparent = true
        btnTurnOff.action = #selector(MainViewController.turnOffBlender)

        return btnTurnOff
    }

}
