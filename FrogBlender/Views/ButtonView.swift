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
    class func makeBlenderButtons(for destViewController: NSViewController) {
        for index in 0...blenderButtons.count - 1 {
            blenderButtons[index] = NSButton(frame: NSRect(origin: blenderButtonsPositions[index],
                                                           size: blenderButtonSize))
            blenderButtons[index].title = ""
            blenderButtons[index].tag = index + 1   // tag for which blender speed button was pressed (1-10)
            blenderButtons[index].isTransparent = true
            blenderButtons[index].action = #selector(GameViewController.speedButtonClicked(sender:))
            blenderButtons[index].addTrackingArea(for: destViewController,
                                                  userInfo: [UserInfoKey.btnName: ControlButtonType.btnSpeedGear])
        }
    }

    class func removeBlenderButtons() {
        for index in 0...blenderButtons.count - 1 {
            blenderButtons[index].removeFromSuperview()
        }
    }

    class func makePlayButton(for destViewController: NSViewController) -> NSButton {
        guard let btnPlayImage = NSImage(named: .playStandard) else {
            fatalError("Image for btnPlayImage cannot be found.")
        }

        let imageWidth = btnPlayImage.size.width
        let imageHeight = btnPlayImage.size.height

        btnPlay = NSButton(frame: NSRect(origin: CGPoint(x: 29, y: 98),
                                         size: CGSize(width: imageWidth, height: imageHeight)))
        btnPlay.image = btnPlayImage
        btnPlay.imagePosition = .imageOnly
        btnPlay.isBordered = false
        btnPlay.action = #selector(GameViewController.startPlaying)
        btnPlay.addTrackingArea(for: destViewController,
                                userInfo: [UserInfoKey.btnName: ControlButtonType.btnPlay])

        return btnPlay
    }

    class func makeReplayButton(for destViewController: NSViewController) -> NSButton {
        guard let btnReplayImage = NSImage(named: .replayStandard) else {
            fatalError("Image for btnReplayImage cannot be found.")
        }

        let imageWidth = btnReplayImage.size.width
        let imageHeight = btnReplayImage.size.height

        btnReplay = NSButton(frame: NSRect(origin: CGPoint(x: 756, y: 23),
                                           size: CGSize(width: imageWidth, height: imageHeight)))
        btnReplay.image = btnReplayImage
        btnReplay.imagePosition = .imageOnly
        btnReplay.isBordered = false
        btnReplay.action = #selector(GameViewController.replayGame)
        btnReplay.addTrackingArea(for: destViewController,
                                  userInfo: [UserInfoKey.btnName: ControlButtonType.btnReplay])

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
