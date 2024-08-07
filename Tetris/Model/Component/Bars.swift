//
//  Bars.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2020/08/21.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import Foundation

final class Bars {
    var theBar: [[Bs]] = []
    var values: [[Bs]] = []
    var cp = Cp(px: 0, py: 0)
    var removeCount: Int = 0

    init() {
        values = Bs.inital
    }

    func initalize() {
        cp.px = DPX
        cp.py = DPY
    }

    func setBar() {
        for tate in 0 ..< theBar.count {
            for yoko in 0 ..< theBar[tate].count {
                values[tate][DPX + yoko] = theBar[tate][yoko]
            }
        }
    }

    func move() {
        RMS()
        for tate in 0 ..< theBar.count {
            for yoko in 0 ..< theBar[tate].count {
                if theBar[tate][yoko].status == .move {
                    values[tate + cp.py][yoko + cp.px] = theBar[tate][yoko]
                }
            }
        }
    }

    func spin() {
        var first: [Bs] = []
        var second: [Bs] = []
        var third: [Bs] = []
        var fourth: [Bs] = []
        for tate in 0 ..< theBar.count {
            let barYoko = theBar[tate]

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
                if lv.status == .move {
                    isFlag = true
                }
            }
            if isFlag != true {
                rotations.remove(at: rotations.count - 1)
                rotations.insert(Bs.yoko, at: 0)
            }
        }
        theBar = rotations
    }

    var bar: [[Int]] {
        BarLists[Tetris.randomNumber(BarLists.count)]
    }

    func getTheBar() {
        theBar = Bars.createBar(bars: bar)
        setBar()
    }

    static func createBar(bars: [[Int]]) -> [[Bs]] {
        var bar: [[Bs]] = []
        for tate in 0 ..< bars.count {
            var yoko = Bs.barYoko
            for index in 0 ..< bars[tate].count {
                if bars[tate][index] == 1 {
                    yoko[index].status = .move
                }
            }
            bar.append(yoko)
        }
        return bar
    }

    func fixPosition() -> Bool {
        if cp.px <= 0 {
            cp.px = 0
        }
        if cp.px >= (Yoko - 3) {
            cp.px = (Yoko - 3) - 1
        }
        for tate in 0 ..< theBar.count {
            for yoko in 0 ..< theBar[tate].count {
                if theBar[tate][yoko].status == .move {
                    if values[cp.py + tate][cp.px + yoko].status == .store {
                        return true
                    }
                }
            }
        }
        return false
    }

    func down(gameOver: () -> Void) {
        guard !isGameOver else {
            gameOver()
            return
        }
        for _ in 0 ..< Tate {
            BarLog(bar: values)
            guard isBottom else {
                initalize()
                break
            }
            cp.py += 1
            move()
            BarLog(bar: values)
        }
        initalize()
    }

    func store() {
        for tate in 0 ..< values.count {
            for yoko in 0 ..< values[tate].count {
                if values[tate][yoko].status == .move {
                    values[tate][yoko].status = .store
                }
            }
        }
    }

    func isRemove() -> Bool {
        removeCount = 0
        var isDisappear = false
        for index in 0 ..< values.count {
            let isRemove = values[index].allSatisfy { $0.status != .nothing }
            if isRemove {
                removeCount += 1
                isDisappear = true
                values[index] = Bs.animationYoko
            }
        }
        return isDisappear
    }

    func removeAnimation() {
        BarLog(bar: values)
        for index in 0 ..< values.count {
            let isRemove = values[index].allSatisfy { $0.status == .animation }
            if isRemove {
                values.remove(at: index)
                BarLog(bar: values)
                values.insert(Bs.yoko, at: 0)
                BarLog(bar: values)
            }
        }
    }

    var isBottom: Bool {
        for tate in 0 ..< values.count {
            for yoko in 0 ..< values[tate].count {
                if values[tate][yoko].status == .move {
                    if tate >= Tate - 1 {
                        return false
                    }
                    if values[tate + 1][yoko].status == .store {
                        return false
                    }
                }
            }
        }
        return true
    }

    var isGameOver: Bool {
        for tate in 0 ..< theBar.count {
            for yoko in 0 ..< values[tate].count {
                if values[tate][yoko].status == .store {
                    print("-----------\n🫡GAME OVER🫡\n-----------")
                    return true
                }
            }
        }
        return false
    }

    func RMS() {
        for tate in 0 ..< values.count {
            for yoko in 0 ..< values[tate].count {
                if values[tate][yoko].status == .move {
                    values[tate][yoko] = Bs()
                }
            }
        }
    }

    var right: Bool {
        if swipe(.right) {
            cp.px += 1
            move()
            return true
        }
        return false
    }

    var left: Bool {
        if swipe(.left) {
            cp.px -= 1
            move()
            return true
        }
        return false
    }

    private func swipe(_ which: Which) -> Bool {
        for tate in 0 ..< values.count {
            for yoko in 0 ..< values[tate].count {
                if values[tate][yoko].status == .move {
                    if which == .right, yoko >= (Yoko - 1) {
                        return false
                    }
                    if which == .left, yoko <= 0 {
                        return false
                    }
                }
            }
        }
        return true
    }
}
