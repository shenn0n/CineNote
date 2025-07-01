//
//  AppDelegate.swift
//  CineNote
//
//  Created by Александр Манжосов on 29.06.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let appearanceNavigationBar = UINavigationBarAppearance()
        appearanceNavigationBar.configureWithOpaqueBackground()
        appearanceNavigationBar.backgroundColor = UIColor(named: "bottom")
        appearanceNavigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "yellow") ?? .white]
        appearanceNavigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "yellow") ?? .white]

        UINavigationBar.appearance().standardAppearance = appearanceNavigationBar
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceNavigationBar
        UINavigationBar.appearance().compactAppearance = appearanceNavigationBar
        UINavigationBar.appearance().tintColor = UIColor(named: "yellow")
        
        
        let appearanceTabBar = UITabBarAppearance()
        appearanceTabBar.configureWithOpaqueBackground()
        appearanceTabBar.backgroundColor = UIColor(named: "bottom") ?? .white
        
        // Цвет иконок и текста (неактивных и активных)
        UITabBar.appearance().tintColor = UIColor(named: "yellow") // Активная иконка
        UITabBar.appearance().unselectedItemTintColor = .gray // Неактивная
        UITabBar.appearance().standardAppearance = appearanceTabBar
        UITabBar.appearance().scrollEdgeAppearance = appearanceTabBar
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

