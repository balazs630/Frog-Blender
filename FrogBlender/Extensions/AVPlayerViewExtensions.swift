//
//  AVPlayerViewExtensions.swift
//  FrogBlender
//
//  Created by Horváth Balázs on 2017. 07. 11..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import AVKit

extension AVPlayerView {
    override open func scrollWheel(with event: NSEvent) {
        // Disable scrolling that can cause accidental video playback control (seek)
        return
    }

    override open func keyDown(with event: NSEvent) {
        // Disable space key (do not pause video playback)
        let spaceBarKeyCode = UInt16(49)
        if event.keyCode == spaceBarKeyCode {
            return
        }
    }
}
