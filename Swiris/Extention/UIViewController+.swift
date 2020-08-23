//
//  UIViewController+.swift
//  FammNYCard
//
//  Created by keisuke yamagishi on 2020/08/03.
//  Copyright © 2020 Timers, Inc. All rights reserved.
//

import UIKit

// MARK: - UIAlertController

extension UIAlertController {
    public func addAction(actions: [AlertAction]) {
        actions.forEach { action in
            if let textField = action.textField {
                self.addTextField { text in
                    text.config(textField)
                }
            } else {
                self.addAction(UIAlertAction(title: action.title, style: action.style, handler: { [unowned self] alertAction in
                    action.handler?(alertAction, self.textFields)
                }))
            }
        }
    }
}

// MARK: - UIViewController

extension UIViewController {
    public func alert(title: String?,
                      message: String? = nil,
                      actions: [AlertAction] = [AlertAction(title: "OK")],
                      preferredStyle: UIAlertController.Style = .alert,
                      vc: UIViewController? = nil)
    {
        let parentVc = vc ?? self
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alertController.addAction(actions: actions)
        parentVc.present(alertController, animated: true)
        // TODO: Please delete follwoing code when it's fixed.
        alertController.view.subviews.forEach {
            $0.removeConstraints($0.constraints.filter { $0.description.contains("width == - 16") })
        }
    }

    func navigationTitle(title: String) -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "MarkerFelt-Thin", size: 16)
        titleLabel.text = title
        titleLabel.sizeToFit()
        return titleLabel
    }
}

// MARK: - UITextField

private extension UITextField {
    func config(_ textField: UITextField) {
        text = textField.text
        placeholder = textField.placeholder
        tag = textField.tag
        isSecureTextEntry = textField.isSecureTextEntry
        tintColor = textField.tintColor
        textColor = textField.textColor
        textAlignment = textField.textAlignment
        borderStyle = textField.borderStyle
        leftView = textField.leftView
        leftViewMode = textField.leftViewMode
        rightView = textField.rightView
        rightViewMode = textField.rightViewMode
        background = textField.background
        disabledBackground = textField.disabledBackground
        clearButtonMode = textField.clearButtonMode
        inputView = textField.inputView
        inputAccessoryView = textField.inputAccessoryView
        clearsOnInsertion = textField.clearsOnInsertion
        keyboardType = textField.keyboardType
        returnKeyType = textField.returnKeyType
        spellCheckingType = textField.spellCheckingType
        autocapitalizationType = textField.autocapitalizationType
        autocorrectionType = textField.autocorrectionType
        keyboardAppearance = textField.keyboardAppearance
        enablesReturnKeyAutomatically = textField.enablesReturnKeyAutomatically
        delegate = textField.delegate
        clearsOnBeginEditing = textField.clearsOnBeginEditing
        adjustsFontSizeToFitWidth = textField.adjustsFontSizeToFitWidth
        minimumFontSize = textField.minimumFontSize

        if #available(iOS 11.0, *) {
            self.textContentType = textField.textContentType
        }

        if #available(iOS 11.0, *) {
            self.smartQuotesType = textField.smartQuotesType
            self.smartDashesType = textField.smartDashesType
            self.smartInsertDeleteType = textField.smartInsertDeleteType
        }

        if #available(iOS 12.0, *) {
            self.passwordRules = textField.passwordRules
        }
    }
}
