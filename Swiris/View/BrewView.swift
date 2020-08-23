//
//  BrewView.swift
//  Swiris
//
//  Created by keisuke yamagishi on 2020/08/22.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit

class BrewView: UIView {
    var barSize: CGFloat {
        frame.size.width / CGFloat(Yoko)
    }

    var fieldHeight: CGFloat {
        return barSize * CGFloat(Tate)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure() {
        configureField()
    }

    func configureField() {
        var barTag = 1
        for tate in 0 ..< Tate {
            for yoko in 0 ..< Yoko {
                let bar: Bar = Bar(frame: CGRect(x: CGFloat(yoko) * barSize,
                                                 y: CGFloat(tate) * barSize,
                                                 width: CGFloat(barSize),
                                                 height: CGFloat(barSize)), tag: barTag)
                addSubview(bar)
                barTag += 1
            }
        }
    }

    func barInitialze() {
        var tag: Int = 1
        for _ in 0 ..< Tate {
            for _ in 0 ..< Yoko {
                let bar: Bar = viewWithTag(tag) as! Bar
                bar.noBrew()
                tag += 1
            }
        }
    }

    func barDisplay(bars: [[Bs]]) {
        var tag: Int = 1

        for tate in 0 ..< Tate {
            let isBar: [Bs] = bars[tate]

            for yoko in 0 ..< Yoko {
                if isBar[yoko].bp == Bars.Move {
                    let bar = viewWithTag(tag) as! Bar
                    bar.brew(isBar[yoko].bc)

                } else if isBar[yoko].bp != Bars.Store {
                    let bar: Bar = viewWithTag(tag) as! Bar
                    bar.noBrew()
                }
                tag += 1
            }
        }
    }

    func storedDisplay(bars: [[Bs]]) {
        var tag: Int = 1
        for tate in 0 ..< Tate {
            let isBar: [Bs] = bars[tate]

            for yoko in 0 ..< Yoko {
                if isBar[yoko].bp == Bars.Store {
                    let bar = viewWithTag(tag) as! Bar
                    bar.brew(isBar[yoko].bc)
                } else {
                    let bar = viewWithTag(tag) as! Bar
                    bar.noBrew()
                }
                tag += 1
            }
        }
    }
}
