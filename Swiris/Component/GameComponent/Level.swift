//
//  Level.swift
//  Breris
//
//  Created by Shichimitoucarashi on 2017/11/05.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import Foundation

let LEVEL12 = 200_000
let LEVEL11 = 150_000
let LEVEL10 = 100_000
let LEVEL9 = 80000
let LEVEL8 = 70000
let LEVEL7 = 60000
let LEVEL6 = 50000
let LEVEL5 = 40000
let LEVEL4 = 23000
let LEVEL3 = 10000
let LEVEL2 = 3000

final class LevelManager {
    var currentLevel: Int = 1

    var isLvUp: Bool = false

    static let levels: [String] = ["0.9", "0.8", "0.7", "0.6", "0.5", "0.4", "0.3", "0.2", "0.15", "0.1", "0.09", "0.085"]

    var levelStr: String = "Lv: "

    var levelText: String {
        levelStr + String(currentLevel)
    }

    var levelCount: Float {
        Float(LevelManager.levels[currentLevel - 1]) ?? 0.0
    }

    func isLevelUp(score: Int) -> Bool {
        let lv = levelSelect(score: score)
        if lv > currentLevel {
            currentLevel = lv
            isLvUp = true
            return true
        }
        return false
    }

    func levelSelect(score: Int) -> Int {
        if score > LEVEL11, score < LEVEL12 {
            return 12
        } else if score > LEVEL10, score < LEVEL11 {
            return 11
        } else if score > LEVEL9, score < LEVEL10 {
            return 10
        } else if score > LEVEL8, score < LEVEL9 {
            return 9
        } else if score > LEVEL7, score < LEVEL8 {
            return 8
        } else if score > LEVEL6, score < LEVEL7 {
            return 7
        } else if score > LEVEL5, score < LEVEL6 {
            return 6
        } else if score > LEVEL4, score < LEVEL5 {
            return 5
        } else if score > LEVEL3, score < LEVEL4 {
            return 4
        } else if score > LEVEL2, score < LEVEL3 {
            return 3
        } else if score > 0, score < LEVEL2 {
            return 2
        }
        return currentLevel
    }
}
