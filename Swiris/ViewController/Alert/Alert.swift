//
//  Alert.swift
//  FammNYCard
//
//  Created by keisuke yamagishi on 2020/08/03.
//  Copyright © 2020 Timers, Inc. All rights reserved.
//

import UIKit

// MARK: - Action

struct AlertAction {
    let title: String
    let type: Int
    let textField: UITextField?
    let style: UIAlertAction.Style
    var handler: ((UIAlertAction, [UITextField]?) -> Void)?

    init(title: String = "",
         type: Int = 0,
         textField: UITextField? = nil,
         placeholder: String? = nil,
         style: UIAlertAction.Style = .default,
         handler: ((UIAlertAction, [UITextField]?) -> Void)? = nil)
    {
        self.title = title
        self.type = type
        self.textField = textField
        if self.textField != nil,
            placeholder != nil
        {
            self.textField?.placeholder = placeholder
        }
        self.handler = handler
        self.style = style
    }
}
