//
//  NSImageExtensions.swift
//  Frog Blender
//
//  Created by Horváth Balázs on 2018. 04. 29..
//  Copyright © 2018. Horváth Balázs. All rights reserved.
//

import Cocoa

public extension NSImage {
    convenience internal init!(named: ImageAssetIdentifier) {
        self.init(named: named.rawValue)
    }
}
