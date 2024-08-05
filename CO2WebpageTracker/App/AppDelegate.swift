//
//  AppDelegate.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 11.06.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 34)
        ]
        UINavigationBar.appearance().tintColor = Colours.WebPageColours.darkOrange
        UINavigationBar.appearance().barTintColor = Colours.BackgroundsColours.light
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitleAttributes
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

