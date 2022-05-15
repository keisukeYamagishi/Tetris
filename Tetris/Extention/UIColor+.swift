//
//  UIColor+.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2020/08/22.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var h = hex
        if h.hasPrefix("#") {
            h = h.replacingOccurrences(of: "#", with: "")
        }

        let hs = h.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))

        let rv = CGFloat(Int(hs[0] + hs[1], radix: 16) ?? 0) / 255.0
        let gv = CGFloat(Int(hs[2] + hs[3], radix: 16) ?? 0) / 255.0
        let bv = CGFloat(Int(hs[4] + hs[5], radix: 16) ?? 0) / 255.0

        self.init(red: rv, green: gv, blue: bv, alpha: alpha)
    }
}
