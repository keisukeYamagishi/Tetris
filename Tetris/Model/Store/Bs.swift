//
//  Bs.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2023/06/22.
//  Copyright © 2023 shichimitoucarashi. All rights reserved.
//

import Foundation

struct Bs {
    var bp = 0
    var bc = 0
    init() {}
}

extension Bs {
    static let yoko: [Bs] = YokoRange.map { _ in .init() }
    static let inital: [[Bs]] = TateRange.map { _ in YokoRange.map { _ in .init() } }
}
