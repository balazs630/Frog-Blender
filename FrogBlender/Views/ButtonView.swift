//
//  ButtonView.swift
//  FrogBlender
//
//  Created by Horváth Balázs on 2017. 07. 05..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class ButtonView: NSView {

    // MARK: Constants
    static var blenderButtons = Array(repeating: NSButton(), count: 10)

    static var blenderButtonsPositions = [
        CGPoint(x: 309, y: 57),
        CGPoint(x: 336, y: 61),
        CGPoint(x: 364, y: 67),
        CGPoint(x: 392, y: 75),
        CGPoint(x: 422, y: 83),
        CGPoint(x: 452, y: 90),
        CGPoint(x: 481, y: 98),
        CGPoint(x: 510, y: 107),
        CGPoint(x: 536, y: 117),
        CGPoint(x: 563, y: 129)
    ]

    static var blenderButtonSize = CGSize(width: 20, height: 20)

    static var btnPlay = NSButton()
    static var btnReplay = NSButton()
    static var btnTurnOff = NSButton()

    // MARK: - UI NSButton configurations
    class func addBlenderButtons(to view: NSViewController) {
        for index in 0...blenderButtons.count - 1 {
            blenderButtons[index] = NSButton(frame: NSRect(origin: blenderButtonsPositions[index],
                                                       size: blenderButtonSize))
            blenderButtons[index].title = ""
            blenderButtons[index].tag = index + 1   // tag for which blender speed button was pressed (1-10)
            blenderButtons[index].isTransparent = true
            blenderButtons[index].action = #selector(GameViewController.speedButtonClicked(sender:))
            let area = NSTrackingArea.init(rect: blenderButtons[index].bounds,
                                           options: [.mouseEnteredAndExited, .activeAlways],
                                           owner: view,
                                           userInfo: [UserInfoKey.btnName: ButtonType.btnSpeedGear])
            blenderButtons[index].addTrackingArea(area)
        }
    }

    class func removeBlenderButtons() {
        for index in 0...blenderButtons.count - 1 {
            blenderButtons[index].removeFromSuperview()
        }
    }

    class func addPlayButton(to view: NSViewController) -> NSButton {
        if let btnPlayImage = NSImage(named: .playStandard) {
            let imageWidth = btnPlayImage.size.width
            let imageHeight = btnPlayImage.size.height

            btnPlay = NSButton(frame: NSRect(origin: CGPoint(x: 29, y: 98),
                                             size: CGSize(width: imageWidth, height: imageHeight)))
            btnPlay.image = btnPlayImage
            btnPlay.imagePosition = .imageOnly
            btnPlay.isBordered = false
            btnPlay.action = #selector(GameViewController.startPlaying)
            let area = NSTrackingArea.init(rect: btnPlay.bounds,
                                           options: [.mouseEnteredAndExited, .activeAlways],
                                           owner: view,
                                           userInfo: [UserInfoKey.btnName: ButtonType.btnPlay])
            btnPlay.addTrackingArea(area)
        }
        return btnPlay
    }

    class func addReplayButton(to view: NSViewController) -> NSButton {
        if let btnReplayImage = NSImage(named: .replayStandard) {
            let imageWidth = btnReplayImage.size.width
            let imageHeight = btnReplayImage.size.height

            btnReplay = NSButton(frame: NSRect(origin: CGPoint(x: 756, y: 23),
                                               size: CGSize(width: imageWidth, height: imageHeight)))
            btnReplay.image = btnReplayImage
            btnReplay.imagePosition = .imageOnly
            btnReplay.isBordered = false
            btnReplay.action = #selector(GameViewController.replayGame)
            let area = NSTrackingArea.init(rect: btnReplay.bounds,
                                           options: [.mouseEnteredAndExited, .activeAlways],
                                           owner: view,
                                           userInfo: [UserInfoKey.btnName: ButtonType.btnReplay])
            btnReplay.addTrackingArea(area)
        }
        return btnReplay
    }

    class func makeTurnOffButton() -> NSButton {
        btnTurnOff = NSButton(frame: NSRect(origin: CGPoint(x: 423, y: 124),
                                            size: CGSize(width: 50, height: 15)))
        btnTurnOff.title = ""
        btnTurnOff.rotate(byDegrees: CGFloat(-15))
        btnTurnOff.isTransparent = true
        btnTurnOff.action = #selector(GameViewController.turnOffBlender)

        return btnTurnOff
    }
}
