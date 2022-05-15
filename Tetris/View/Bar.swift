//
//  Bar.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2020/08/21.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit

class Bar: UIView {
    convenience init(frame: CGRect, tag: Int) {
        self.init(frame: frame)
        self.tag = tag
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        backgroundColor = UIColor.white
        layer.borderColor = BorderColor.cgColor
        layer.borderWidth = 1.0
    }

    func noBrew() {
        backgroundColor = UIColor.white
        layer.borderColor = BorderColor.cgColor
        layer.borderWidth = 1.0
    }

    func brew(_ color: Int) {
        backgroundColor = Color.colorList(cNum: color)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
}
