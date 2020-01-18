//
//  NavigationController.swift
//  Swiris
//
//  Created by Shichimitoucarashi on 2020/01/17.
//  Copyright © 2020 shichimitoucarashi. All rights reserved.
//

import UIKit

extension UIViewController {
    func navigationTitle(title: String) -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "MarkerFelt-Thin", size: 16)
        titleLabel.text = title
        titleLabel.sizeToFit()
        return titleLabel
    }
}
