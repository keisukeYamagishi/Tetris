//
//  DebugLog.swift
//  Breris
//
//  Created by Shichimitoucarashi on 2017/11/04.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print("\(items)", separator: separator, terminator: terminator)
    #endif
}

func BarLog(bar: [[Bs]]) {
    print("Bar")
    for f in bar {
        f.forEach { print($0.bp, terminator: "") }
        print("")
    }
}

func ColorLog(bar: [[Bs]]) {
    print("Color")
    for f in bar {
        f.forEach { print($0.bc, terminator: "") }
        print("")
    }
}