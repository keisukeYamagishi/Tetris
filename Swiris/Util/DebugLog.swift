//
//  DebugLog.swift
//  Breris
//
//  Created by Shichimitoucarashi on 2017/11/04.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import Foundation

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print("\(items)", separator: separator, terminator: terminator)
    #endif
}

public func BarLog(bar: [[Bs]]) {
    print("Bar")
    for f in bar {
        f.forEach { print($0.bc, terminator: "") }
        print("")
    }
}
