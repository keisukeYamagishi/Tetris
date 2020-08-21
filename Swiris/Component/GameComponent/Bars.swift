//
//  Bars.swift
//  Swiris
//
//  Created by keisuke yamagishi on 2020/08/21.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit

var Yoko: Int = 10 // 7
var Tate: Int = 20 // 11var brewrisYoko: Int = 10 // 7
var DPX = 4
var DPY = 0

public struct Bs {
    var bp = 0
    var bc = 0
}

class Bars {
    var values: [[Bs]] = []
    var noneed: [Cp] = []
    var cp: Cp = Cp(px: 0, py: 0)
    var numberOfCount: Int {
        values.count
    }

    var yokoValue: [Bs] {
        var yoko: [Bs] = []
        for _ in 0 ..< Yoko {
            let bs = Bs()
            yoko.append(bs)
        }
        return yoko
    }

    init() {
        for _ in 0 ..< Tate {
            values.append(yokoValue)
        }
    }
}

extension Bars {
    func move(bar: [[Int]], cColor: Int) {
        var noNeedCo: Int = 0
        var storeNoNeed: [Cp] = []

        for tate in 0 ..< bar.count {
            let baryoko: [Int] = bar[tate]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko] == 1 {
                    var brew: [Bs] = values[cp.py + tate]
                    brew[yoko + cp.px].bp = 1
                    brew[yoko + cp.px].bc = cColor
                    values[cp.py + tate] = brew

                    storeNoNeed.append(Cp(px: cp.px + yoko, py: cp.py + tate))
                    noNeedCo += 1
                }
            }
        }
        noneed = storeNoNeed
    }

    func spin(bars: [[Int]]) -> [[Int]] {
        var first: [Int] = Array()
        var second: [Int] = Array()
        var third: [Int] = Array()
        var fourth: [Int] = Array()

        for tate in 0 ..< bars.count {
            let barYoko: [Int] = bars[tate]

            for yoko in 0 ..< barYoko.count {
                switch yoko {
                case 3:
                    first.append(barYoko[yoko])
                case 2:
                    second.append(barYoko[yoko])
                case 1:
                    third.append(barYoko[yoko])
                case 0:
                    fourth.append(barYoko[yoko])
                default:
                    break
                }
            }
        }

        var rotations = [first, second, third, fourth]

        for _ in 0 ..< rotations.count {
            var isFlag = false

            for lv in rotations.last! {
                if lv == 1 {
                    isFlag = true
                }
            }

            if isFlag != true {
                rotations.remove(at: rotations.count - 1)
                rotations.insert([0, 0, 0, 0], at: 0)
            }
        }
        return rotations
    }
}
