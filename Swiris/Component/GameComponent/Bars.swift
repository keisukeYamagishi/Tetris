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

struct Cp {
    var px = 0
    var py = 0
}

enum Which: Int {
    case left = 0
    case right = 1
}

struct Bs {
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
    var removeLists: [Int] = []
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

    static var getTheBar: [[Int]] {
        BarLists[Int(arc4random_uniform(UInt32(BarLists.count)))]
    }

    func fixPosition(bar: [[Int]]) -> Bool {
        if cp.px <= 0 {
            cp.px = 0
            // return true
        }

        if cp.px >= (Yoko - 3) {
            cp.px = (Yoko - 3) - 1
            // return true
        }

        for tate in 0 ..< bar.count {
            let baryoko: [Int] = bar[tate]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko] == 1 {
                    let brew: [Bs] = values[cp.py + tate]
                    let isRot = brew[cp.px + yoko]

                    if isRot.bp == 2 {
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

    func down(bar: [[Int]], gameOver: () -> Void) {
        var isBottom = false
        var count = 1
        let cCp: [Cp] = noneed

        removeCurrent(cCp: cCp)

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

                    for nd in 0 ..< noneed.count {
                        var n = noneed[nd]
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
            if isBottom == true {
                break
            }
            count += 1
        }

        if isBottom == false {
            cp.py = count - 3
            for tate in 0 ..< bar.count {
                let baryoko: [Int] = bar[tate]

                for yoko in 0 ..< baryoko.count {
                    if baryoko[yoko] == Bars.Move {
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
        removeLists = []

        for be in 0 ..< numberOfCount {
            let agreemnent: [Bs] = values[be]
            var isRemove: Bool = false

            for agr in agreemnent {
                if agr.bp == 0 {
                    isRemove = true
                }
            }
            if isRemove != true {
                removeLists.append(be)
            }
        }

        var isRm = false

        for rm in removeLists {
            values.remove(at: rm)

            values.insert(yokoValue, at: rm)

            isRm = true
        }

        if isRm {
            isRm = false

            for rm in removeLists {
                values.remove(at: rm)
                values.insert(yokoValue, at: 0)
            }
            return true
        }
        return false
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

    func isGameOver(bar: [[Int]]) -> Bool {
        for tate in (0 ..< bar.count).reversed() {
            let baryoko: [Int] = bar[tate]

            for yoko in 0 ..< baryoko.count {
                if baryoko[yoko] == 1 {
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
        let flg = !isBarMove(which: which) && !isMoveJusgemnet(which: which)
        return flg
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
