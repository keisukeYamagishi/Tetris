//
//  BarController.swift
//  Breris
//
//  Created by Shichimitoucarashi on 2017/12/18.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import Foundation

class BarController {
    var noNeed: [Cp]!
    var brewTate: [[Bs]]!
    var cp: Cp!
    var CBColor: Int!
    var yoko: Int = 13 // 7
    var tate: Int = 28 // 11

    init() {
        cp = Cp(px: 0, py: 0)
        brewTate = brewrisInit()
    }

    func brewrisInit() -> [[Bs]] {
        var tate: [[Bs]] = Array()
        for _ in 0 ..< self.tate {
            let brewYoko = brewYokoInit()

            tate.append(brewYoko)
        }
        return tate
    }

    func brewYokoInit() -> [Bs] {
        var yoko: [Bs] = Array()

        for _ in 0 ..< self.yoko {
            var bs = Bs()
            bs.bp = 0
            bs.bc = 0
            yoko.append(bs)
        }
        return yoko
    }

    func initNoNeed() -> [Cp] {
        var noNeeds: [Cp] = []
        for _ in 0 ..< 4 {
            noNeeds.append(Cp(px: 0, py: 0))
        }
        return noNeeds
    }

    func moveBrew(bar: [[Any]]) {
        var noNeedCo: Int = 0
        var storeNoNeed: [Cp] = initNoNeed()

        for tate in 0 ..< bar.count {
            let baryoko: [Int] = bar[tate] as! [Int]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko] == 1 {
                    var brew: [Bs] = brewTate[cp.py + tate]
                    brew[yoko + cp.px].bp = 1
                    brew[yoko + cp.px].bc = CBColor
                    brewTate[cp.py + tate] = brew

                    storeNoNeed[noNeedCo] = Cp(px: cp.px + yoko, py: cp.py + tate)
                    noNeedCo += 1
                }
            }
        }
        noNeed = storeNoNeed
    }

    static func rotation(bars: [[Int]]) -> [[Int]] {
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
                    print("default")
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
