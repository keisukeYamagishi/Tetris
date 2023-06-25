//
//  Bs.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2023/06/22.
//  Copyright © 2023 shichimitoucarashi. All rights reserved.
//

import Foundation

enum BarStatus: Int {
    case nothing
    case move
    case store
}

struct Bs {
    var status: BarStatus = .nothing
    var color = 0
    init() {}
}

extension Bs {
    static let barYoko: [Bs] = (0 ..< 4).map { _ in .init() }
    static let yoko: [Bs] = YokoRange.map { _ in .init() }
    static let inital: [[Bs]] = TateRange.map { _ in YokoRange.map { _ in .init() } }
}
