//
//  Constants.swift
//  Frog Blender
//
//  Created by Horváth Balázs on 2018. 04. 29..
//  Copyright © 2018. Horváth Balázs. All rights reserved.
//

import Foundation

struct Constant {
    static let speedButtonCount = 10
}

enum UserInfoKey: String {
    case btnName
}

enum ControlButtonType: String {
    case btnPlay
    case btnReplay
    case btnSpeedGear
}

enum FileType: String {
    case aac
    case mp4
}

enum ImageAssetIdentifier: String {
    case playStandard = "play-standard"
    case playHover = "play-hover"

    case replayStandard = "replay-standard"
    case replayHover = "replay-hover"
}

enum SoundAssetIdentifier: String {
    case playButtonHover = "play-button-hover"

    case replayButtonAppears = "replay-button-appears"
    case replayButtonPressed = "replay-button-pressed"
    case replayButtonHover = "replay-button-hover"

    case blenderSpeedGearButtonPressed = "blender-speed-gear-button-pressed"
    case blenderSpeedGearButtonHover = "blender-speed-gear-button-hover"
}

enum VideoAssetIdentifier: String {
    case intro = "intro"
    case outro = "outro"

    case speed0 = "speed-0"
    case speed1 = "speed-1"
    case speed2 = "speed-2"
    case speed3 = "speed-3"
    case speed4 = "speed-4"
    case speed5 = "speed-5"
    case speed6 = "speed-6"
    case speed7 = "speed-7"
    case speed8 = "speed-8"
    case speed9 = "speed-9"
    case speed10 = "speed-10"
}
