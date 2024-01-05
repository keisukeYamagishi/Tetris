//
//  Animation.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2024/01/05.
//  Copyright © 2024 shichimitoucarashi. All rights reserved.
//

import UIKit

final class Animation {
    var count = 0
    func flashAnimation(targetView: UIView,
                        repeatCount: Int,
                        _ completion: @escaping () -> Void)
    {
        targetView.alpha = 1.0
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       animations: {
                           targetView.alpha = 0.0
                       }, completion: { [self] _ in
                           targetView.alpha = 1.0
                           count += 1
                           if repeatCount == count {
                               completion()
                           } else {
                               flashAnimation(targetView: targetView,
                                              repeatCount: repeatCount,
                                              completion)
                           }
                       })
    }
}
