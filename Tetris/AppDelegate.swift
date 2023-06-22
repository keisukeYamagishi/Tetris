//
//  AppDelegate.swift
//  Breris
//
//  Created by shichimi on 2017/07/06.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        rootViewController()
        return true
    }

    private func rootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Tetris", bundle: nil)
        let tetrisViewController = storyboard.instantiateInitialViewController()
        window?.rootViewController = tetrisViewController
        window?.makeKeyAndVisible()
    }
}
