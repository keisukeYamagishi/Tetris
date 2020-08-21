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

public struct Bs {
    var bp = 0
    var bc = 0
}

class Bars {
    var values: [[Bs]] = []
    var noneed: [Cp] = []
    var cp: Cp = Cp(px: 0, py: 0)
    
    init() {
        for _ in 0 ..< Tate {
            var yoko:[Bs] = []
            for _ in 0 ..< Yoko {
                let bs = Bs()
                yoko.append(bs)
            }
            values.append(yoko)
        }
    }
}

extension Bars {
    func moveBrewControl(bar: [[Int]], cColor: Int) {
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
}
