//
//  Bars.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2020/08/21.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit

var Yoko: Int = 10 // 7
var Tate: Int = 20 // 11var brewrisYoko: Int = 10 // 7
var DPX = 4
var DPY = 0

struct Cp {
    var px = 0
    var py = 0
}

enum Which: Int {
    case left = 0
    case right = 1
}

public struct Bs {
    var bp = 0
    var bc = 0
}

final class Bars {
    static let Noting = 0
    static let Move = 1
    static let Store = 2
    var values: [[Bs]] = []
    var noneed: [Cp] = []
    var cp: Cp = Cp(px: 0, py: 0)
    var removeCount: Int = 0
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

    func initalize() {
        noneed = Array()
        cp.px = DPX
        cp.py = DPY
    }

    func move(bar: [[Bs]], cColor: Int) {
        var noNeedCo: Int = 0
        var storeNoNeed: [Cp] = []

        for tate in 0 ..< bar.count {
            let baryoko: [Bs] = bar[tate]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko].bp == 1 {
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

    func spin(bars: [[Bs]]) -> [[Bs]] {
        var first: [Bs] = Array()
        var second: [Bs] = Array()
        var third: [Bs] = Array()
        var fourth: [Bs] = Array()

        for tate in 0 ..< bars.count {
            let barYoko: [Bs] = bars[tate]

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
                if lv.bp == Bars.Move {
                    isFlag = true
                }
            }

            if isFlag != true {
                rotations.remove(at: rotations.count - 1)
                rotations.insert(yokoValue, at: 0)
            }
        }
        return rotations
    }

    static var getTheBar: [[Int]] {
        BarLists[Int(arc4random_uniform(UInt32(BarLists.count)))]
    }

    static func getTheBar(color: Int) -> [[Bs]] {
        Bars.coloring(bars: Bars.getTheBar, color: color)
    }

    static func coloring(bars: [[Int]], color: Int) -> [[Bs]] {
        var bar: [[Bs]] = []
        for tate in 0 ..< bars.count {
            var yoko = Bars.barYoko
            for index in 0 ..< bars[tate].count {
                if bars[tate][index] == Bars.Move {
                    yoko[index].bc = color
                    yoko[index].bp = 1
                }
            }
            bar.append(yoko)
        }

        return bar
    }

    static var barYoko: [Bs] {
        var bars: [Bs] = []
        for _ in 0 ..< 4 {
            bars.append(Bs())
        }
        return bars
    }

    func fixPosition(bar: [[Bs]]) -> Bool {
        if cp.px <= 0 {
            cp.px = 0
            // return true
        }

        if cp.px >= (Yoko - 3) {
            cp.px = (Yoko - 3) - 1
            // return true
        }

        for tate in 0 ..< bar.count {
            let baryoko: [Bs] = bar[tate]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko].bp == Bars.Move {
                    let brew: [Bs] = values[cp.py + tate]
                    let isRot = brew[cp.px + yoko]

                    if isRot.bp == Bars.Store {
                        return true
                    }
                }
            }
        }
        return false
    }

    func store(cbColor: Int) {
        values = storeBar(store: values, cbColor: cbColor)
    }

    func down(bar: [[Bs]], gameOver: () -> Void) {
        var isBottom = false
        var count = 1
        removeCurrent(cCp: noneed)
        while count < (numberOfCount - 1) {
            for current in (0 ..< noneed.count).reversed() {
                let cP: Cp = noneed[current]

                let judge = cP.py + count

                if judge >= Tate {
                    break
                }

                let bar: [Bs] = values[cP.py + count]

                if bar[cP.px].bp == Bars.Store {
                    isBottom = true

                    cp.py = (count - 1) + cP.py

                    for nd in noneed {
                        var n = nd
                        cp.py = (count - 1) + n.py

                        if cp.py == 1 {
                            gameOver()
                            return
                        }

                        n.py = cp.py
                        var tate: [Bs] = values[n.py]
                        tate[n.px].bp = 1
                        values[n.py] = tate
                    }
                    break
                }
            }
            if isBottom {
                break
            }
            count += 1
        }
        if !isBottom {
            cp.py = count - 3
            for tate in 0 ..< bar.count {
                let baryoko: [Bs] = bar[tate]

                for yoko in 0 ..< baryoko.count {
                    if baryoko[yoko].bp == Bars.Move {
                        var brew: [Bs] = values[cp.py + tate]
                        brew[yoko + cp.px].bp = 1
                        values[cp.py + tate] = brew
                    }
                }
            }
        }
    }

    func storeBar(store: [[Bs]], cbColor: Int) -> [[Bs]] {
        var stores = store

        for tate in 0 ..< stores.count {
            var yokos: [Bs] = stores[tate]

            for yoko in 0 ..< yokos.count {
                if yokos[yoko].bp == Bars.Move {
                    yokos[yoko].bp = Bars.Store
                    yokos[yoko].bc = cbColor
                    stores[tate] = yokos
                }
            }
        }
        return stores
    }

    func isInAgreement() -> Bool {
        removeCount = 0
        var isInAgreement = false
        for index in 0 ..< numberOfCount {
            var isRemove = true
            let yoko = values[index]
            for bar in yoko {
                if bar.bp == 0 {
                    isRemove = false
                }
            }
            if isRemove {
                isInAgreement = true
                removeCount += 1
                values.remove(at: index)
                values.insert(yokoValue, at: 0)
            }
        }
        return isInAgreement
    }

    var isBottom: Bool {
        let bottom = Tate - 1
        for current in noneed {
            if bottom <= current.py {
                return true
            }
        }
        return false
    }

    func judgementBrew() -> Bool {
        for current in (0 ..< noneed.count).reversed() {
            let cPosition = noneed[current]

            let bar = values[cPosition.py + 1]

            if bar[cPosition.px].bp == Bars.Store {
                return true
            }
        }
        return false
    }

    func isGameOver(bar: [[Bs]]) -> Bool {
        for tate in (0 ..< bar.count).reversed() {
            let baryoko: [Bs] = bar[tate]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko].bp == Bars.Move {
                    let brew: [Bs] = values[cp.py + tate]
                    if brew[yoko + cp.px].bp != 0 {
                        print("GAME OVER")
                        return true
                    }
                }
            }
        }
        return false
    }

    func noNeedEmurate() {
        for yoko in 0 ..< numberOfCount {
            var tate: [Bs] = values[yoko]

            for brew in 0 ..< tate.count {
                if tate[brew].bp == Bars.Move {
                    tate[brew].bp = 0
                }
            }
            values[yoko] = tate
        }
    }

    func removeCurrent(cCp: [Cp]) {
        for ccp in cCp {
            var br = values[ccp.py]

            br[ccp.px].bp = 0
            br[ccp.px].bc = 0
            values[ccp.py] = br
        }
    }

    func isSwipe(which: Which) -> Bool {
        !isBarMove(which: which) && !isMoveJusgemnet(which: which)
    }

    func isBarMove(which: Which) -> Bool {
        for cpVal in noneed {
            if which == .left {
                if cpVal.px <= 0 {
                    return true
                }
            } else if which == .right {
                if cpVal.px >= (Yoko - 1) {
                    return true
                }
            }
        }
        return false
    }

    func isMoveJusgemnet(which: Which) -> Bool {
        for current in 0 ..< noneed.count {
            let cPosition: Cp = noneed[current]

            let bar: [Bs] = values[cPosition.py]

            if which == .left {
                if bar[cPosition.px - 1].bp == Bars.Store {
                    return true
                }
            } else if which == .right {
                if bar[cPosition.px + 1].bp == Bars.Store {
                    return true
                }
            }
        }
        return false
    }
}
