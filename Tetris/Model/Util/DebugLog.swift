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
    var count = 0
    print("Tetris👾")
    for f in bar {
        f.forEach { print($0.status.rawValue, terminator: "") }
        print(count)
        count += 1
    }
}

func ColorLog(bar: [[Bs]]) {
    print("Color")
    for f in bar {
        f.forEach { print($0.status, terminator: "") }
        print("")
    }
}
