//
//  NSButtonExtension.swift
//  Frog Blender
//
//  Created by Horváth Balázs on 2018. 10. 10..
//  Copyright © 2018. Horváth Balázs. All rights reserved.
//

import Cocoa

extension NSButton {
    func addTrackingArea(for destViewController: NSViewController, userInfo: [UserInfoKey: ControlButtonType]) {
        let area = NSTrackingArea.init(rect: self.bounds,
                                       options: [.mouseEnteredAndExited, .activeAlways],
                                       owner: destViewController,
                                       userInfo: userInfo)
        self.addTrackingArea(area)
    }
}
