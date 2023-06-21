//
//  ColorUtil.swift
//  Breris　03 3361 3949
//  03 3452 1474
//  Created by shichimi on 2017/09/28.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import UIKit

class Color {

    public func barColor() -> UIColor {
        UIColor(hex: ColorPattern[Color.randomNumber()])
    }

    static func NaviBarColor() -> UIColor {
        UIColor(hex: topBarColor)
    }

    static func NaviBarTintColor() -> UIColor {
        UIColor(hex: topBarTintColor)
    }

    static func colorList(cNum: Int) -> UIColor {
        let colorRandom: String = ColorPattern[cNum]
        return UIColor(hex: colorRandom)
    }

    static func baviBarTitleColor() -> UIColor {
        UIColor(hex: naviBarTitleColor)
    }

    static func randomNumber() -> Int {
        Int(arc4random_uniform(UInt32(ColorPattern.count)))
    }
}
