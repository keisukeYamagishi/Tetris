//
//  NextBarField.swift
//  Swiris
//
//  Created by keisuke yamagishi on 2020/08/21.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit

class NextBarField: UIView {
    var bar: Bar!
    var nextBar: [[Int]] = []
    var NBColor: Int = 0
    var color: UIColor {
        bar.backgroundColor ?? .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureField()
    }

    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        configure()
    }

    func configure() {
        configureField()
    }

    func configureField() {
        var tag = 1
        for tate in 0 ..< 4 {
            for yoko in 0 ..< 4 {
                let nextBar = Bar(frame: CGRect(origin: CGPoint(x: CGFloat(yoko) * (74 / 4),
                                                                y: CGFloat(tate) * (74 / 4)),
                                                size: CGSize(width: CGFloat(18.5),
                                                             height: CGFloat(18.5))), tag: tag)
                addSubview(nextBar)
                tag += 1
            }
        }
    }

    func initializeField() {
        var tag = 1
        for _ in 0 ..< 4 {
            for _ in 0 ..< 4 {
                let bar = viewWithTag(tag) as! Bar
                bar.noBrew()
                tag += 1
            }
        }
    }

    func displayNextBar() {
        var tag: Int = 1
        nextBar = Bars.getTheBar // getTheBar()
        NBColor = Color.radomNum() // BarColor()
        for tate in 0 ..< 4 {
            let nb = nextBar[tate]

            for yoko in 0 ..< 4 {
                if nb[yoko] == 1 {
                    let bar = viewWithTag(tag) as! Bar
                    bar.brew(NBColor)
                } else {
                    let bar = viewWithTag(tag) as! Bar
                    bar.noBrew()
                }
                tag += 1
            }
        }
    }
}
