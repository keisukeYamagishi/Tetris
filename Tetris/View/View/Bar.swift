//
//  Bar.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2020/08/21.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit

final class Bar: UIView {
    @IBOutlet private var imageView: UIImageView!

    @IBOutlet var view: UIView! {
        didSet {
            view.frame = bounds
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(view)
        }
    }

    convenience init(frame: CGRect, tag: Int) {
        self.init(frame: frame)
        setup()
        self.tag = tag
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func empty() {
        imageView.image = UIImage(named: "empty.png")
    }

    func present() {
        imageView.image = UIImage(named: "bar.png")
    }

    private func setup() {
        loadNib()
        backgroundColor = UIColor.white
        layer.borderColor = UIColor(named: "TetrisBackgroundColor")?.cgColor
        layer.borderWidth = 2.0
    }

    private func loadNib() {
        UINib(nibName: type(of: self).nibName,
              bundle: nil)
            .instantiate(withOwner: self,
                         options: nil)
    }
}
