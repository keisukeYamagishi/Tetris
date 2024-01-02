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
    case animation
    case store
}

struct Bs {
    var status: BarStatus
    init(_ status: BarStatus = .nothing) {
        self.status = status
    }
}

extension Bs {
    static let barYoko: [Bs] = (0 ..< 4).map { _ in .init() }
    static let yoko: [Bs] = YokoRange.map { _ in .init() }
    static let inital: [[Bs]] = TateRange.map { _ in YokoRange.map { _ in .init() } }
    static let animationYoko: [Bs] = YokoRange.map { _ in .init(.animation) }
}
