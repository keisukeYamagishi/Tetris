//
//  BarFactory.swift
//  Breris
//
//  Created by shichimi on 2017/10/09.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import Foundation

let shikaku = [[0, 0, 0, 0],
               [0, 0, 0, 0],
               [0, 1, 1, 0],
               [0, 1, 1, 0]]

let sBar = [[0, 0, 0, 0],
             [0, 1, 0, 0],
             [0, 1, 1, 0],
             [0, 0, 1, 0]]

let bou = [[0, 0, 1, 0],
           [0, 0, 1, 0],
           [0, 0, 1, 0],
           [0, 0, 1, 0]]

let yama = [[0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 1, 0, 0],
            [1, 1, 1, 0]]

let zBar =  [[0, 0, 0, 0],
              [0, 0, 1, 0],
              [0, 1, 1, 0],
              [0, 1, 0, 0]]

let lBar = [[0, 0, 0, 0],
            [0, 1, 1, 0],
            [0, 0, 1, 0],
            [0, 0, 1, 0]]

let jBar = [[0, 0, 0, 0],
             [0, 1, 1, 0],
             [0, 1, 0, 0],
             [0, 1, 0, 0]]

public var BarLists = [lBar,jBar,zBar,yama,bou,shikaku,sBar]
