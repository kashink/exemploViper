//
//  AppDelegate.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 04/09/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appRouter = AppRouter()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appRouter.start()
        
        return true
    }
}

