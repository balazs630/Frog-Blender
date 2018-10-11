//
//  ButtonFactory.swift
//  FrogBlender
//
//  Created by Horváth Balázs on 2017. 07. 05..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class ButtonFactory {
    // MARK: Properties
    static var blenderButtonPositions = [
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

    static var playButtonPosition = CGPoint(x: 29, y: 98)
    static var replayButtonPosition = CGPoint(x: 756, y: 23)
    static var turnOffButtonPosition = CGPoint(x: 423, y: 124)

    static var blenderButtonSize = CGSize(width: 20, height: 20)
    static var turnOffButtonSize = CGSize(width: 50, height: 15)
    static var turnOffBlenderRotation = CGFloat(-15)
}

// MARK: - Make buttons
extension ButtonFactory {
    class func makeSpeedButtons(for destViewController: NSViewController) -> [NSButton] {
        var speedButtons = Array(repeating: NSButton(), count: Constant.speedButtonCount)
        (0...speedButtons.count - 1).forEach { index in
            speedButtons[index] = NSButton(frame: NSRect(origin: blenderButtonPositions[index],
                                                         size: blenderButtonSize))
            speedButtons[index].title = ""
            speedButtons[index].tag = index + 1   // tag for which blender speed button was pressed
            speedButtons[index].isTransparent = true
            speedButtons[index].action = #selector(GameViewController.speedButtonClicked(sender:))
            speedButtons[index].addTrackingArea(for: destViewController,
                                                userInfo: [UserInfoKey.btnName: ControlButtonType.btnSpeedGear])
        }

        return speedButtons
    }

    class func makePlayButton(for destViewController: NSViewController) -> NSButton {
        guard let btnPlayImage = NSImage(named: .playStandard) else {
            fatalError("Image for btnPlayImage cannot be found.")
        }

        let imageWidth = btnPlayImage.size.width
        let imageHeight = btnPlayImage.size.height

        let playButton = NSButton(frame: NSRect(origin: playButtonPosition,
                                                size: CGSize(width: imageWidth, height: imageHeight)))
        playButton.image = btnPlayImage
        playButton.imagePosition = .imageOnly
        playButton.isBordered = false
        playButton.action = #selector(GameViewController.startPlaying)
        playButton.addTrackingArea(for: destViewController,
                                   userInfo: [UserInfoKey.btnName: ControlButtonType.btnPlay])

        return playButton
    }

    class func makeReplayButton(for destViewController: NSViewController) -> NSButton {
        guard let btnReplayImage = NSImage(named: .replayStandard) else {
            fatalError("Image for btnReplayImage cannot be found.")
        }

        let imageWidth = btnReplayImage.size.width
        let imageHeight = btnReplayImage.size.height

        let replayButton = NSButton(frame: NSRect(origin: replayButtonPosition,
                                                  size: CGSize(width: imageWidth, height: imageHeight)))
        replayButton.image = btnReplayImage
        replayButton.imagePosition = .imageOnly
        replayButton.isBordered = false
        replayButton.action = #selector(GameViewController.replayGame)
        replayButton.addTrackingArea(for: destViewController,
                                     userInfo: [UserInfoKey.btnName: ControlButtonType.btnReplay])

        return replayButton
    }

    class func makeTurnOffButton() -> NSButton {
        let turnOffButton = NSButton(frame: NSRect(origin: turnOffButtonPosition,
                                                   size: turnOffButtonSize))
        turnOffButton.title = ""
        turnOffButton.rotate(byDegrees: turnOffBlenderRotation)
        turnOffButton.isTransparent = true
        turnOffButton.action = #selector(GameViewController.turnOffBlender)

        return turnOffButton
    }
}
