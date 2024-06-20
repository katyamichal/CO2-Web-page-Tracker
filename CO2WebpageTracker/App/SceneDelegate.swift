//
//  SceneDelegate.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 11.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let  window = UIWindow(windowScene: windowScene)
        coordinator = TabBarCoordinator(window: window, networkService: NetworkService(), dataService: DataService())
        coordinator?.start()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {

    }
    
    func sceneWillResignActive(_ scene: UIScene) {

    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
    }
}
