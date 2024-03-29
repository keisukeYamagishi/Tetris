//
//  Which.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2023/06/22.
//  Copyright © 2023 shichimitoucarashi. All rights reserved.
//

import Foundation

enum Which: Int {
    case left = 0
    case right = 1
}

extension Which {
    var toValue: Int {
        switch self {
        case .left:
            return -1
        case .right:
            return 1
        }
    }
}
