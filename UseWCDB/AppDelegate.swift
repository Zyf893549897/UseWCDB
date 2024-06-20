//
//  AppDelegate.swift
//  UseWCDB
//
//  Created by 张云飞 on 2024/6/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        let nav = UINavigationController.init(rootViewController: ViewController.init())
        window?.rootViewController = nav
        return true
    }


}

