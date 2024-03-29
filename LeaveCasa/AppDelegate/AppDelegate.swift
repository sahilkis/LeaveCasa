//
//  AppDelegate.swift
//  LeaveCasa
//
//  Created by Apple on 17/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        for family: String in UIFont.familyNames {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
        checkUserStatus()
        setNavigationBar()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - MAKE CUSTOM NAVIGATIONBAR
extension AppDelegate {
    func setNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = LeaveCasaColors.BLUE_COLOR
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_18 ?? UIFont.systemFont(ofSize: 18)]
    }
}

// MARK: - CHECK IF USER IS LOGGED IN OR NOT
extension AppDelegate {
    func checkUserStatus() {
        print(Helper.getBoolPREF(UserDefaults.PREF_REMEMBER_ME))
        if Helper.getBoolPREF(UserDefaults.PREF_REMEMBER_ME) {
            if let vc = ViewControllerHelper.getViewController(ofType: .SWRevealViewController) as? SWRevealViewController {
                let navigationController = UINavigationController.init(rootViewController: vc)
                navigationController.setNavigationBarHidden(true, animated: false)
                self.window?.rootViewController = navigationController
            }
        }
    }
}
