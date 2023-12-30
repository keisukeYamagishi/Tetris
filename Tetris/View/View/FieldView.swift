//
//  BrewView.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2020/08/22.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit

final class FieldView: UIView {
    var barSize: CGFloat {
        frame.size.width / CGFloat(Yoko)
    }

    var height: CGFloat {
        barSize * CGFloat(Tate)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure() {
        var barTag = 1
        for tate in 0 ..< Tate {
            for yoko in 0 ..< Yoko {
                let bar = Bar(frame: CGRect(x: CGFloat(yoko) * barSize,
                                            y: CGFloat(tate) * barSize,
                                            width: CGFloat(barSize),
                                            height: CGFloat(barSize)),
                              tag: barTag)
                addSubview(bar)
                barTag += 1
            }
        }
    }

    func initialze() {
        var tag = 1
        for _ in 0 ..< Tate {
            for _ in 0 ..< Yoko {
                let bar = viewWithTag(tag) as! Bar
                bar.empty()
                tag += 1
            }
        }
    }

    func barDisplay(bars: [[Bs]]) {
        var tag = 1
        for tate in 0 ..< Tate {
            let isBar: [Bs] = bars[tate]
            for yoko in 0 ..< Yoko {
                if isBar[yoko].status == .move
                    || isBar[yoko].status == .store
                {
                    let bar = viewWithTag(tag) as! Bar
                    bar.present()
                } else {
                    let bar = viewWithTag(tag) as! Bar
                    bar.empty()
                }
                tag += 1
            }
        }
    }
}
