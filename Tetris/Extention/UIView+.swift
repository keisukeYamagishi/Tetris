//
//  UIView+.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2023/06/25.
//  Copyright © 2023 shichimitoucarashi. All rights reserved.
//

import UIKit.UIView

extension UIView {
    class var nibName: String {
        String(describing: self)
    }

    func flashAnimation(_ completion: @escaping () -> Void) {
        alpha = 1.0
        UIView.animate(withDuration: 1.0,
                       delay: 1.0,
                       animations: { [self] in
            alpha = 0.0
        }, completion: { [self] _ in
            alpha = 1.0
            completion()
        })
    }
}
