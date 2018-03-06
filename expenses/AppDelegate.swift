//
//  AppDelegate.swift
//  expenses
//
//  Created by Nour  on 8/1/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import DropDown
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userDefulat = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        DropDown.startListeningToKeyboard()
        // Override point for customization after application launch.
        NavigationBarStyle()
        setTabBarStyle()
        loadUser()
        loadView()
        addDocumentTypes()
        return true
    }
    
    
    
    func addDocumentTypes(){
    let types = ["Quotation","Order","Delivery","Return","Invoice","Credit Note"]
        
        for type in types {
            let dcType = DocumnetType(id: -1, title: type, userid: 1)
            dcType.save()
        }
    
    }
    
    func NavigationBarStyle(){
        // remove under line
        
        let attrs = [NSForegroundColorAttributeName : UIColor.orange ,
                     NSFontAttributeName : UIFont.systemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attrs
        // set background color
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .orange
        
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    
    }
    
    func setTabBarStyle(){
        
        UITabBar.appearance().tintColor = .orange
    }
    
    func loadUser(){
    
        if let username = userDefulat.string(forKey: "username"),let password = userDefulat.string(forKey: "password"){
            if let user = DatabaseManagement.shared.queryUserbyNameandPass(username: username, pass: password){
                Globals.user = user
                Globals.isLogedin = true
            }
        }
    
    }
    
    func loadView(){
    
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    
        let vc = UIStoryboard.viewController(identifier: "StartViewController") as! StartViewController
    let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
    
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

