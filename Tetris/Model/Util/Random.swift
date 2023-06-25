//
//  Random.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2023/06/24.
//  Copyright © 2023 shichimitoucarashi. All rights reserved.
//

import Foundation

func randomNumber(_ limit: Int) -> Int {
    Int(arc4random_uniform(UInt32(limit)))
}
