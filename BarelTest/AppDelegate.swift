//
//  AppDelegate.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 19.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shared:AppDelegate?
    var safeArea:UIEdgeInsets?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.shared = self
        self.safeArea = self.window?.safeAreaInsets
        print(#function, self.safeArea?.top ?? "-----", "safeAreasafeAreasafeAreasafeArea")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = Globals.User.username == "" ? "LoginVC" : "TabBarController"
        print(vc,"vcvcvcvc")
        let initialViewController = storyboard.instantiateViewController(withIdentifier: vc)
            
        
        self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        
        return true
    }




}

