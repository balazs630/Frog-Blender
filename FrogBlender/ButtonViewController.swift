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

    static var blenderButtonPos = [CGPoint(x: 307, y: 58),
                                   CGPoint(x: 335, y: 62),
                                   CGPoint(x: 363, y: 68),
                                   CGPoint(x: 391, y: 76),
                                   CGPoint(x: 421, y: 84),
                                   CGPoint(x: 450, y: 91),
                                   CGPoint(x: 479, y: 99),
                                   CGPoint(x: 508, y: 108),
                                   CGPoint(x: 534, y: 118),
                                   CGPoint(x: 561, y: 130)]

    static var blenderButtonSize = CGSize(width: 20, height: 20)

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

    class func addPlayButton(to view: NSViewController) -> NSButton {
        if let btnPlayImage = NSImage(named: "play-standard") {
            let imageWidth = btnPlayImage.size.width
            let imageHeight = btnPlayImage.size.height

            btnPlay = NSButton(frame: NSRect(origin: CGPoint(x: 29, y: 98), size: CGSize(width: imageWidth, height: imageHeight)))
            btnPlay.image = btnPlayImage
            btnPlay.imagePosition = .imageOnly
            btnPlay.isBordered = false
            btnPlay.action = #selector(MainViewController.startPlaying)
            let area = NSTrackingArea.init(rect: ButtonViewController.btnPlay.bounds, options: [NSTrackingAreaOptions.mouseEnteredAndExited, NSTrackingAreaOptions.activeAlways], owner: view, userInfo: nil)
            btnPlay.addTrackingArea(area)
        }
        return btnPlay
    }

    class func addReplayButton(to view: NSViewController) -> NSButton {
        if let btnReplayImage = NSImage(named: "play-again-standard") {
            let imageWidth = btnReplayImage.size.width
            let imageHeight = btnReplayImage.size.height

            btnReplay = NSButton(frame: NSRect(origin: CGPoint(x: 754, y: 23), size: CGSize(width: imageWidth, height: imageHeight)))
            btnReplay.image = btnReplayImage
            btnReplay.imagePosition = .imageOnly
            btnReplay.isBordered = false
            btnReplay.action = #selector(MainViewController.replayGame)
            let area = NSTrackingArea.init(rect: ButtonViewController.btnReplay.bounds, options: [NSTrackingAreaOptions.mouseEnteredAndExited, NSTrackingAreaOptions.activeAlways], owner: view, userInfo: nil)
            btnReplay.addTrackingArea(area)
        }
        return btnReplay
    }

    class func addTurnOffButton() -> NSButton {
        btnTurnOff = NSButton(frame: NSRect(origin: CGPoint(x: 422, y: 125), size: CGSize(width: 50, height: 15)))
        btnTurnOff.title = ""
        btnTurnOff.rotate(byDegrees: CGFloat(-15))
        btnTurnOff.isTransparent = true
        btnTurnOff.action = #selector(MainViewController.turnOffBlender)

        return btnTurnOff
    }

}
