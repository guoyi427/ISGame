//
//  AppDelegate.swift
//  ISGame
//
//  Created by 郭毅 on 2017/4/15.
//  Copyright © 2017年 郭毅. All rights reserved.
//

import UIKit

let Host = "192.168.1.105:8080"
let Socket_Host = "wx://192.168.1.105:8282/chat"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let tabBarC = UITabBarController()
        let homeVC = HomeViewController()
        homeVC.title = "首页"
        let pcVC = PersonalCenterViewController()
        pcVC.title = "个人中心"
        
        tabBarC.viewControllers = [UINavigationController(rootViewController: homeVC), UINavigationController(rootViewController: pcVC)]
        window!.rootViewController = tabBarC
        window!.makeKeyAndVisible()
        
        _judgeLogin()
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

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

extension AppDelegate {
    /// 判断是否登陆
    fileprivate func _judgeLogin() {
        if UserControl.shared.getUid() == "" {
            let loginVC = LoginViewController()
            let navi = UINavigationController(rootViewController: loginVC)
            loginVC.navigationController?.setNavigationBarHidden(true, animated: false)
            window!.rootViewController!.present(navi, animated: true, completion: nil)
        } else {
            SocketControl.instance.connectHost()
        }
    }
}

