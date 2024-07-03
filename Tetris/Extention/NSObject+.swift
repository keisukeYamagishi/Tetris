//
//  NSObject+.swift
//  Tetris
//
//  Created by keisuke yamagishi on 2024/07/03.
//  Copyright © 2024 shichimitoucarashi. All rights reserved.
//

import Foundation

extension NSObject {
    class var nibName: String {
        String(describing: self)
    }
}
