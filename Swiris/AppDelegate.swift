//
//  AppDelegate.swift
//  Breris
//
//  Created by shichimi on 2017/07/06.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        rootViewController()
        return true
    }

    private func rootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateInitialViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController!)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
