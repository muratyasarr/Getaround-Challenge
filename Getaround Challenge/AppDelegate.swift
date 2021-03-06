//
//  AppDelegate.swift
//  Getaround Challenge
//
//  Created by Guest User on 17.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let moviesViewController = MoviesViewController(networkManager: NetworkManager())
        window?.rootViewController = UINavigationController(rootViewController: moviesViewController)
        window?.makeKeyAndVisible()
        return true
    }

}

