//
//  AppDelegate.swift
//  FrogBlender
//
//  Created by Horváth Balázs on 2017. 07. 01..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
