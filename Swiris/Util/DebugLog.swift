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
        Swift.print("\(items)", separator:separator, terminator: terminator)
    #endif
}

public func BarLog(bar: [Array<Bs>]) {
    
    for b in 0..<bar.count {
        
        var list: [Int] = []
        
        let debug = bar[b]
        
        for bs in debug {
            list.append(bs.bp)
        }
        print(list)
    }
}
